//
//  ViewController.m
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "ViewController.h"

#import "SampleLayoutManager.h"
#import "SampleTile.h"

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    self.scatterCardView.expandGuideView.topImage = [UIImage imageNamed:@"normal_top.gif"];
    self.scatterCardView.expandGuideView.cornerImage = [UIImage imageNamed:@"normal_corner.gif"];
    
    self.scatterCardView.expandGuideView.topAnimationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"normal_top.gif"], [UIImage imageNamed:@"loading_top_00.gif"], [UIImage imageNamed:@"loading_top_01.gif"], [UIImage imageNamed:@"loading_top_02.gif"], [UIImage imageNamed:@"loading_top_01.gif"], [UIImage imageNamed:@"loading_top_00.gif"], nil];
    self.scatterCardView.expandGuideView.cornerAnimationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"normal_corner.gif"], [UIImage imageNamed:@"loading_corner_00.gif"], [UIImage imageNamed:@"loading_corner_01.gif"], [UIImage imageNamed:@"loading_corner_02.gif"], [UIImage imageNamed:@"loading_corner_01.gif"], [UIImage imageNamed:@"loading_corner_00.gif"], nil];
    self.scatterCardView.expandGuideView.animationDuration = 1.2f;
    
    self.scatterCardView.scrollView.maximumZoomScale = 1.4f;
    self.scatterCardView.scrollView.minimumZoomScale = 0.6f;
}

#pragma mark - properties

- (id<HIUIScatterCardViewLayoutManager>)layoutManager {
    if ( nil == _layoutManager ) {
        _layoutManager = [[SampleLayoutManager alloc] init];
    }
    
    return _layoutManager;
}

#pragma mark - HIUIScatterCardView dataSource

- (UIView<HIUIScatterCardTile> *)scatterCardView:(HIUIScatterCardView *)scatterCardView tileAtIndexPath:(NSIndexPath *)indexPath {
    SampleTile* tile = (SampleTile*)[scatterCardView dequeueReusableTileWithIdentifier:[SampleTile reuseIdentifier]];
    if ( nil == tile ) {
        tile = [[SampleTile alloc] initWithFrame:CGRectZero];
    }
    
    tile.label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return tile;
}

- (BOOL)canFetchMoreInScatterCardView:(HIUIScatterCardView *)scatterCardView {
    return NO;
}

- (NSInteger)numberOfDataInScatterCardView:(HIUIScatterCardView *)scatterCardView {
    return 1000;
}

#pragma mark - HIUIScatterCardView delegate

- (void)scatterCardView:(HIUIScatterCardView *)scatterCardView shouldFetchDataWithDirection:(HIUIScatterCardViewExpandDirection)direction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [scatterCardView onFetchedDataWithDirection:direction];
    });
}

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

- (void)scatterCardView:(HIUIScatterCardView *)scatterCardView transformTile:(UIView<HIUIScatterCardTile> *)tile atIndexPath:(NSIndexPath *)indexPath {
    tile.transform = CGAffineTransformRotate(CGAffineTransformIdentity, DegreesToRadians(indexPath.row * 8 % 20 - 10));
}

- (void)scatterCardView:(HIUIScatterCardView *)scatterCardView didSelectTileAtIndexPath:(NSIndexPath *)indexPath {
}

@end
