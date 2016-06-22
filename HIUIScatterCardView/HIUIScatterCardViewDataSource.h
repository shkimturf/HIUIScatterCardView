//
//  HIUIScatterCardViewDataSource.h
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIUIScatterCardTile.h"
#import "HIUIScatterCardGuideView.h"

@class HIUIScatterCardView;
@protocol HIUIScatterCardViewDataSource <NSObject>

- (BOOL)canFetchMoreInScatterCardView:(HIUIScatterCardView*)scatterCardView;
- (NSInteger)numberOfDataInScatterCardView:(HIUIScatterCardView*)scatterCardView;
- (UIView<HIUIScatterCardTile>*)scatterCardView:(HIUIScatterCardView*)scatterCardView tileAtIndexPath:(NSIndexPath*)indexPath;
- (void)scatterCardView:(HIUIScatterCardView *)scatterCardView shouldFetchDataWithDirection:(HIUIScatterCardViewExpandDirection)direction;

@optional
- (void)scatterCardView:(HIUIScatterCardView*)scatterCardView transformTile:(UIView<HIUIScatterCardTile>*)tile atIndexPath:(NSIndexPath*)indexPath;

@end
