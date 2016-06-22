//
//  HIUIScatterCardView.h
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HIUIScatterCardViewDataSource.h"
#import "HIUIScatterCardViewDelegate.h"
#import "HIUIScatterCardViewLayoutManager.h"

#import "HIUIScatterCardGuideView.h"

@interface HIUIScatterCardView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    UIScrollView* _scrollView;
    HIUIScatterCardGuideView* _expandGuideView;
    UIView* _contentView;
    
    NSMutableDictionary* _reuseQueue;
    NSMutableArray* _itemData;
    
    BOOL _shouldConstructTile;
    
    UILongPressGestureRecognizer* _tapRec;
    UIView<HIUIScatterCardTile>* _highlightedTile;
    
    NSUInteger _allocatedDataIndex;
    
    BOOL _prohibitLoadingTileByScroll;
}

@property (nonatomic, assign) NSUInteger reuseQueueCap;

@property (nonatomic, assign) id<HIUIScatterCardViewDataSource> dataSource;
@property (nonatomic, assign) id<HIUIScatterCardViewDelegate> delegate;
@property (nonatomic, strong) id<HIUIScatterCardViewLayoutManager> layoutManager;

@property (nonatomic, strong, readonly) NSArray* visibleItemViews;

@property (nonatomic, strong, readonly) UIScrollView* scrollView;
@property (nonatomic, strong, readonly) HIUIScatterCardGuideView* expandGuideView;

@property (nonatomic, assign) CGFloat minimumZoomScale;
@property (nonatomic, assign) CGFloat maximumZoomScale;

@property (nonatomic, assign, readonly) NSInteger numberOfCurrentCells;

- (id)initWithFrame:(CGRect)frame layoutManager:(id<HIUIScatterCardViewLayoutManager>)layoutManager;

- (void)reloadData;
- (void)loadVisibleTiles;
- (void)reloadDataWithDataIndex:(NSInteger)index;

- (void)releaseAllViews;

- (UIView<HIUIScatterCardTile>*)dequeueReusableTileWithIdentifier:(NSString*)identifier;

- (void)onFetchedDataWithDirection:(HIUIScatterCardViewExpandDirection)direction;

@end
