//
//  HIUIScatterCardView.m
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "HIUIScatterCardView.h"

#import "HIScatterCardData.h"
#import "HIUIScatterCardViewCommon.h"

@implementation HIUIScatterCardView
@synthesize scrollView=_scrollView, expandGuideView=_expandGuideView;

- (id)initWithFrame:(CGRect)frame layoutManager:(id<HIUIScatterCardViewLayoutManager>)layoutManager {
    self = [super initWithFrame:frame];
    if (self) {
        _reuseQueue = [[NSMutableDictionary alloc] init];
        _itemData = [[NSMutableArray alloc] init];
        
        self.reuseQueueCap = REUSE_QUEUE_CAP;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.scrollView.scrollsToTop = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        _expandGuideView = [[HIUIScatterCardGuideView alloc] initWithFrame:self.bounds];
        self.expandGuideView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.expandGuideView.backgroundColor = [UIColor clearColor];
        self.expandGuideView.expandMode = HIUIScatterCardViewExpandModeDisabled;
        [self.scrollView addSubview:self.expandGuideView];
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _contentView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_contentView];
        
        _shouldConstructTile = YES;
        self.layoutManager = layoutManager;
        
        _tapRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onTapInView:)];
        _tapRec.minimumPressDuration = 0.001f;
        _tapRec.delegate = self;
        [self addGestureRecognizer:_tapRec];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"Not supports, use initWithFrame:layoutManager");
    return nil;
}

- (void)awakeFromNib {
    NSAssert(NO, @"Not supports, use initWithFrame:layoutManager");
}

#pragma mark - observation

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.expandGuideView.frame = CGRectMake(0.f, 0.f, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    _contentView.frame = CGRectMake(0.f, 0.f, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

#pragma mark - properties

- (void)setLayoutManager:(id<HIUIScatterCardViewLayoutManager>)layoutManager {
    NSAssert(nil != layoutManager, @"Cannot assign layoutManager to nil.");
    _layoutManager = layoutManager;
    
    [self reloadData];
}

- (NSArray *)visibleItemViews {
    CGRect visibleBounds = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
    NSMutableArray* tiles = [[NSMutableArray alloc] init];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( NO == [obj conformsToProtocol:@protocol(HIUIScatterCardTile)] ) {
            return;
        }
        
        UIView<HIUIScatterCardTile>* tile = obj;
        if ( CGRectContainsRect(visibleBounds, tile.frame) || CGRectIntersectsRect(visibleBounds, tile.frame) ) {
            [tiles addObject:tile];
        }
    }];
    
    return [NSArray arrayWithArray:tiles];
}

- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale {
    _minimumZoomScale = minimumZoomScale;
    self.scrollView.minimumZoomScale = self.minimumZoomScale;
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale {
    _maximumZoomScale = maximumZoomScale;
    self.scrollView.maximumZoomScale = self.maximumZoomScale;
}

- (NSInteger)numberOfCurrentCells {
    if ( 0 == _itemData.count ) {
        return 0;
    }
    
    return (_itemData.count * ((NSArray*)[_itemData objectAtIndex:0]).count);
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ( NO == _shouldConstructTile ) {
        return;
    }
    
    // reset item data
    [_itemData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray* row = obj;
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            HIScatterCardData* data = obj;
            [self _enqueueReusableTile:data.tile];
        }];
    }];
    [_itemData removeAllObjects];
    
    [self _layoutInitialCells];
    [self _loadVisibleTiles];
    [self dataUpdated];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( _prohibitLoadingTileByScroll ) {
        return;
    }
    
    [self _loadVisibleTiles];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ( HIUIScatterCardViewExpandModeWaiting != self.expandGuideView.expandMode ) {
        return;
    }
    
    // check expansion direction
    HIUIScatterCardViewExpandDirection direction = HIUIScatterCardViewExpandDirectionNone;
    if ( scrollView.contentOffset.x < -DEFAULT_LOADMORE_VIEW_HEIGHT ) {
        direction |= HIUIScatterCardViewExpandDirectionLeft;
    } else if ( scrollView.contentSize.width + DEFAULT_LOADMORE_VIEW_HEIGHT < self.scrollView.contentOffset.x + CGRectGetWidth(self.bounds)) {
        direction |= HIUIScatterCardViewExpandDirectionRight;
    }
    
    if ( scrollView.contentOffset.y < -DEFAULT_LOADMORE_VIEW_HEIGHT ) {
        direction |= HIUIScatterCardViewExpandDirectionTop;
    } else if ( scrollView.contentSize.height + DEFAULT_LOADMORE_VIEW_HEIGHT < self.scrollView.contentOffset.y + CGRectGetHeight(self.bounds)) {
        direction |= HIUIScatterCardViewExpandDirectionBottom;
    }
    
    if ( HIUIScatterCardViewExpandDirectionNone == direction ) {
        return;
    }
    
    // set content inset
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if ( direction & HIUIScatterCardViewExpandDirectionTop ) {
        inset.top = DEFAULT_LOADMORE_VIEW_HEIGHT;
    }
    if ( direction & HIUIScatterCardViewExpandDirectionLeft ) {
        inset.left = DEFAULT_LOADMORE_VIEW_HEIGHT;
    }
    if ( direction & HIUIScatterCardViewExpandDirectionBottom ) {
        inset.bottom = DEFAULT_LOADMORE_VIEW_HEIGHT;
    }
    if ( direction & HIUIScatterCardViewExpandDirectionRight ) {
        inset.right = DEFAULT_LOADMORE_VIEW_HEIGHT;
    }
    
    [UIView animateWithDuration:0.1f delay:0.f options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.scrollView.contentInset = inset;
    } completion:nil];
    self.expandGuideView.expandMode = HIUIScatterCardViewExpandModeLoading;
    self.expandGuideView.expandDirection = direction;
    
    
    NSInteger numberOfCellsToExpand = 0;
    for ( int i = 0 ; i < self.layoutManager.initialPanelLevel ; i++ ) {
        if ( direction & HIUIScatterCardViewExpandDirectionLeft || direction & HIUIScatterCardViewExpandDirectionRight ) {
            numberOfCellsToExpand += _itemData.count;
        }
        if ( direction & HIUIScatterCardViewExpandDirectionTop || direction & HIUIScatterCardViewExpandDirectionBottom ) {
            numberOfCellsToExpand += ((NSArray*)[_itemData objectAtIndex:0]).count;
        }
        if ( direction & HIUIScatterCardViewExpandDirectionTopLeft || direction & HIUIScatterCardViewExpandDirectionTopRight || direction & HIUIScatterCardViewExpandDirectionBottomLeft || direction & HIUIScatterCardViewExpandDirectionBottomRight ) {
            numberOfCellsToExpand += 1;
        }
    }
    
    if ( _itemData.count - self.numberOfCurrentCells  < numberOfCellsToExpand ) {
        [self.dataSource scatterCardView:self shouldFetchDataWithDirection:direction];
    } else if ( [self.dataSource canFetchMoreInScatterCardView:self] ) {
        [self onFetchedDataWithDirection:direction];
    } else {
        [self onFetchedDataWithDirection:direction];
        self.expandGuideView.expandMode = HIUIScatterCardViewExpandModeDisabled;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _contentView;
}

#pragma mark - manage data

- (void)reloadData {
    _shouldConstructTile = YES;
    
    [self setNeedsLayout];
}

- (void)loadVisibleTiles {
    [self _loadVisibleTiles];
}

- (void)reloadDataWithDataIndex:(NSInteger)index {
    __block BOOL shouldStop = NO;
    [_itemData enumerateObjectsUsingBlock:^(id obj, NSUInteger rowIdx, BOOL *stop) {
        NSArray* row = obj;
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger columnIdx, BOOL *stop) {
            HIScatterCardData* data = obj;
            
            if ( data.index == index ) {
                shouldStop = YES;
                [self _enqueueReusableTile:data.tile];
                data.tile = nil;
            }
            
            *stop = shouldStop;
        }];
        
        *stop = shouldStop;
    }];
    
    [self loadVisibleTiles];
}

- (void)releaseAllViews {
    [_itemData enumerateObjectsUsingBlock:^(id obj, NSUInteger rowIdx, BOOL *stop) {
        NSArray* row = obj;
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger columnIdx, BOOL *stop) {
            HIScatterCardData* data = obj;
            [self _enqueueReusableTile:data.tile];
        }];
    }];
}

- (void)dataUpdated {
    if ( 0 == _itemData.count ) {
        return;
    }
    
    self.expandGuideView.expandMode = HIUIScatterCardViewExpandModeWaiting;
//    if ( [self.dataSource numberOfDataInScatterCardView:self] > self.numberOfCurrentCells ) {
//        self.expandGuideView.expandMode = HIUIScatterCardViewExpandModeWaiting;
//    } else if ( [self.dataSource canFetchMoreInScatterCardView:self] ) {
//        self.expandGuideView.expandMode = HIUIScatterCardViewExpandModeWaiting;
//    }
}

#pragma mark - reuse

- (UIView<HIUIScatterCardTile>*)dequeueReusableTileWithIdentifier:(NSString*)identifier {
    NSMutableArray* stack = [_reuseQueue objectForKey:identifier];
    UIView<HIUIScatterCardTile>* tile = [stack lastObject];
    if ( nil != tile ) {
        [stack removeLastObject];
    }
    
    return tile;
}

- (void)_enqueueReusableTile:(UIView<HIUIScatterCardTile>*)tile {
    if ( nil == tile ) {
        return;
    }
    
    [tile removeFromSuperview];
    
    // reset itemView to re-use
    tile.tag = UNKNOWN_TILE_TAG;
    if ( [tile respondsToSelector:@selector(initiateTile)] ) {
        [tile initiateTile];
    }
    
    NSString* identifier = [[tile class] reuseIdentifier];
    NSMutableArray* stack = [_reuseQueue objectForKey:identifier];
    if ( nil == stack ) {
        stack = [[NSMutableArray alloc] initWithCapacity:self.reuseQueueCap];
        [_reuseQueue setObject:stack forKey:identifier];
    }
    
    if ( stack.count < self.reuseQueueCap ) {
        [stack addObject:tile];
    }
}

#pragma mark - private functions

- (void)_layoutInitialCells {
    NSAssert(0 == _itemData.count, @"Invalid status");
    
    for ( int i = 0 ; i < self.layoutManager.initialPanelLevel ; i++ ) {
        [self _expandPanelWithDirection:HIUIScatterCardViewExpandDirectionAll];
    }
    
    [self _loadCenterPositionInPanel];
    
    // set scrollview properties
    CGSize cellSize = self.layoutManager.cellSize;
    self.scrollView.contentSize = CGSizeMake(cellSize.width * _itemData.count * self.scrollView.zoomScale, cellSize.height * _itemData.count * self.scrollView.zoomScale);
    self.expandGuideView.frame = CGRectMake(0.f, 0.f, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    _contentView.frame = CGRectMake(0.f, 0.f, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    // set center position
    self.scrollView.contentOffset = CGPointMake((self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds)) / 2.f, (self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds)) / 2.f);
    
    if ( [self.delegate respondsToSelector:@selector(scatterCardView:didExpandedWithCellCount:)] ) {
        [self.delegate scatterCardView:self didExpandedWithCellCount:self.numberOfCurrentCells];
    }
}

- (void)_loadVisibleTiles {
    CGRect visibleBounds = CGRectZero;
    visibleBounds.origin = self.scrollView.contentOffset;
    visibleBounds.size = self.scrollView.bounds.size;
    
    float scale = 1.0 / self.scrollView.zoomScale;
    visibleBounds.origin.x *= scale;
    visibleBounds.origin.y *= scale;
    visibleBounds.size.width *= scale;
    visibleBounds.size.height *= scale;
    
    CGSize cellSize = self.layoutManager.cellSize;
    [_itemData enumerateObjectsUsingBlock:^(id obj, NSUInteger rowIdx, BOOL *stop) {
        NSArray* row = obj;
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger columnIdx, BOOL *stop) {
            HIScatterCardData* data = obj;
            
            CGRect frame = CGRectMake(data.center.x - cellSize.width / 2.f, data.center.y - cellSize.height / 2.f, cellSize.width, cellSize.height);
            if ( CGRectContainsRect(visibleBounds, frame) || CGRectIntersectsRect(visibleBounds, frame) ) {
                [self _loadItemDataAtPoint:CGPointMake(rowIdx, columnIdx) reload:NO];
            } else {
                [self _enqueueReusableTile:data.tile];
                data.tile = nil;
            }
        }];
    }];
}

- (void)_loadItemDataAtPoint:(CGPoint)point reload:(BOOL)reload {
    HIScatterCardData* data = [[_itemData objectAtIndex:point.x] objectAtIndex:point.y];
    if ( [self.dataSource numberOfDataInScatterCardView:self] < data.index + 1 ) {
        return;
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:data.index inSection:DEFAULT_SECTION_INDEXPATH];
    
    if ( reload ) {
        [self _enqueueReusableTile:data.tile];
        data.tile = nil;
    }
    
    if ( nil == data.tile ) {
        data.tile = [self.dataSource scatterCardView:self tileAtIndexPath:indexPath];
        [_contentView addSubview:data.tile];
        
        // set tile
        data.tile.tag = data.index;
        data.tile.frame = CGRectMake(0.f, 0.f, self.layoutManager.tileSize.width, self.layoutManager.tileSize.height);
        
        if ( [self.dataSource respondsToSelector:@selector(scatterCardView:transformTile:atIndexPath:)] ) {
            [self.dataSource scatterCardView:self transformTile:data.tile atIndexPath:indexPath];
        }
    }
    
    data.tile.center = data.center;
}

// this point is not pixel point, data row, column
- (CGRect)_cellFrameAtPoint:(CGPoint)point {
    CGSize cellSize = self.layoutManager.cellSize;
    return CGRectMake(cellSize.width * point.x, cellSize.height * point.y, cellSize.width, cellSize.height);
}

- (void)_expandPanelWithDirection:(HIUIScatterCardViewExpandDirection)direction {
    if ( 0 == _itemData.count ) {
        HIScatterCardData* data = [[HIScatterCardData alloc] init];
        data.index = _allocatedDataIndex = 0;
        [_itemData addObject:[[NSMutableArray alloc] initWithObjects:data, nil]];
        return;
    }
    
    if ( direction & HIUIScatterCardViewExpandDirectionTop ) {
        NSInteger numberOfColumns = ((NSArray*)[_itemData objectAtIndex:0]).count;
        NSMutableArray* row = [[NSMutableArray alloc] init];
        for ( int i = 0 ; i < numberOfColumns ; i++ ) {
            HIScatterCardData* data = [[HIScatterCardData alloc] init];
            data.index = ++_allocatedDataIndex;
            [row addObject:data];
        }
        
        [_itemData insertObject:row atIndex:0];
    }
    
    if ( direction & HIUIScatterCardViewExpandDirectionBottom ) {
        NSInteger numberOfColumns = ((NSArray*)[_itemData objectAtIndex:0]).count;
        NSMutableArray* row = [[NSMutableArray alloc] init];
        for ( int i = 0 ; i < numberOfColumns ; i++ ) {
            HIScatterCardData* data = [[HIScatterCardData alloc] init];
            data.index = ++_allocatedDataIndex;
            [row addObject:data];
        }
        
        [_itemData addObject:row];
    }
    
    if ( direction & HIUIScatterCardViewExpandDirectionLeft ) {
        [_itemData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableArray* row = obj;
            HIScatterCardData* data = [[HIScatterCardData alloc] init];
            data.index = ++_allocatedDataIndex;
            
            [row insertObject:data atIndex:0];
        }];
    }
    
    if ( direction & HIUIScatterCardViewExpandDirectionRight ) {
        [_itemData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableArray* row = obj;
            HIScatterCardData* data = [[HIScatterCardData alloc] init];
            data.index = ++_allocatedDataIndex;
            
            [row addObject:data];
        }];
    }
}

- (void)_loadCenterPositionInPanel {
    CGSize cellSize = self.layoutManager.cellSize;
    [_itemData enumerateObjectsUsingBlock:^(id obj, NSUInteger rowIdx, BOOL *stop) {
        NSArray* row = obj;
        [row enumerateObjectsUsingBlock:^(id obj, NSUInteger columnIdx, BOOL *stop) {
            HIScatterCardData* data = obj;
            data.center = CGPointMake(cellSize.height * columnIdx + cellSize.height / 2.f, cellSize.width * rowIdx + cellSize.width / 2.f);
        }];
    }];
}

- (void)onFetchedDataWithDirection:(HIUIScatterCardViewExpandDirection)direction {
    
    CGSize offsetChanged = CGSizeZero;
    CGSize expandedSize = CGSizeZero;
    CGSize cellSize = self.layoutManager.cellSize;
    for ( int i = 0 ; i < self.layoutManager.initialPanelLevel ; i++ ) {
        NSInteger numberOfCurrentCells = self.numberOfCurrentCells;
        NSInteger numberOfCellsToExpand = 0;
        
        if ( direction & HIUIScatterCardViewExpandDirectionLeft || direction & HIUIScatterCardViewExpandDirectionRight ) {
            numberOfCellsToExpand += _itemData.count;
        }
        if ( direction & HIUIScatterCardViewExpandDirectionTop || direction & HIUIScatterCardViewExpandDirectionBottom ) {
            numberOfCellsToExpand += ((NSArray*)[_itemData objectAtIndex:0]).count;
        }
        if ( direction & HIUIScatterCardViewExpandDirectionTopLeft || direction & HIUIScatterCardViewExpandDirectionTopRight || direction & HIUIScatterCardViewExpandDirectionBottomLeft || direction & HIUIScatterCardViewExpandDirectionBottomRight ) {
            numberOfCellsToExpand += 1;
        }
        
        [self _expandPanelWithDirection:direction];
        
        if ( direction & HIUIScatterCardViewExpandDirectionLeft ) {
            offsetChanged.width += cellSize.width;
        }
        if ( direction & HIUIScatterCardViewExpandDirectionTop ) {
            offsetChanged.height += cellSize.height;
        }
        
        if ( direction & HIUIScatterCardViewExpandDirectionLeft || direction & HIUIScatterCardViewExpandDirectionRight ) {
            expandedSize.width += cellSize.width;
        }
        if ( direction & HIUIScatterCardViewExpandDirectionTop || direction & HIUIScatterCardViewExpandDirectionBottom ) {
            expandedSize.height += cellSize.height;
        }
    }
    
    expandedSize.width *= self.scrollView.zoomScale;
    expandedSize.height *= self.scrollView.zoomScale;
    offsetChanged.width *= self.scrollView.zoomScale;
    offsetChanged.height *= self.scrollView.zoomScale;
    
    if ( direction & HIUIScatterCardViewExpandDirectionLeft ) {
        offsetChanged.width -= DEFAULT_LOADMORE_VIEW_HEIGHT;
    }
    
    if ( direction & HIUIScatterCardViewExpandDirectionTop ) {
        offsetChanged.height -= DEFAULT_LOADMORE_VIEW_HEIGHT;
    }
    
    if ( NO == CGSizeEqualToSize(expandedSize, CGSizeZero) ) {
        [self _loadCenterPositionInPanel];
        
        _prohibitLoadingTileByScroll = YES;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width + expandedSize.width, self.scrollView.contentSize.height + expandedSize.height);
        self.expandGuideView.frame = CGRectMake(0.f, 0.f, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
        _contentView.frame = CGRectMake(0.f, 0.f, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
        
        self.scrollView.contentInset = UIEdgeInsetsZero;
        if ( NO == CGSizeEqualToSize(offsetChanged, CGSizeZero) ) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + offsetChanged.width, self.scrollView.contentOffset.y + offsetChanged.height);
        }
        _prohibitLoadingTileByScroll = NO;
        [self _loadVisibleTiles];
        [self dataUpdated];
    } else {
        [UIView animateWithDuration:0.35f animations:^{
            self.scrollView.contentInset = UIEdgeInsetsZero;
        } completion:^(BOOL finished) {
            [self dataUpdated];
        }];
        
        return;
    }
    
    if ( [self.delegate respondsToSelector:@selector(scatterCardView:didExpandedWithCellCount:)] ) {
        [self.delegate scatterCardView:self didExpandedWithCellCount:self.numberOfCurrentCells];
    }
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ( [touch.view isKindOfClass:[UIButton class]] ) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - user interaction

- (UIView<HIUIScatterCardTile>*)_indexPathAtPoint:(CGPoint)point {
    UIView* view = [self.scrollView hitTest:point withEvent:nil];
    while ( self.scrollView != view ) {
        if ( [view conformsToProtocol:@protocol(HIUIScatterCardTile)] ) {
            return (UIView<HIUIScatterCardTile>*)view;
        }
        view = view.superview;
    }
    
    return nil;
}

- (void)onTapInView:(UIGestureRecognizer*)rec {
    UIView<HIUIScatterCardTile>* tile = [self _indexPathAtPoint:[rec locationInView:self.scrollView]];
    switch ( rec.state ) {
        case UIGestureRecognizerStateBegan:
        {
            if ( nil == tile ) {
                return;
            }
            
            NSAssert(nil == _highlightedTile, @"Item selected already!");
            _highlightedTile = tile;
            
            if ( [tile respondsToSelector:@selector(setHighlighted:animated:)] ) {
                [tile setHighlighted:YES animated:NO];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if ( nil == _highlightedTile ) {
                return;
            }
            
            if ( [_highlightedTile respondsToSelector:@selector(setHighlighted:animated:)] ) {
                [_highlightedTile setHighlighted:NO animated:NO];
            }
            
            if ( tile == _highlightedTile ) {
                if ( [self.delegate respondsToSelector:@selector(scatterCardView:didSelectTileAtIndexPath:)] ) {
                    [self.delegate scatterCardView:self didSelectTileAtIndexPath:[NSIndexPath indexPathForRow:tile.tag inSection:DEFAULT_SECTION_INDEXPATH]];
                }
            }
            
            _highlightedTile = nil;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateChanged:
        {
            if ( nil == _highlightedTile ) {
                return;
            }
            
            if ( [_highlightedTile respondsToSelector:@selector(setHighlighted:animated:)] ) {
                [_highlightedTile setHighlighted:NO animated:NO];
            }
            
            _highlightedTile = nil;
        }
            break;
        default:
            break;
    }
}

@end
