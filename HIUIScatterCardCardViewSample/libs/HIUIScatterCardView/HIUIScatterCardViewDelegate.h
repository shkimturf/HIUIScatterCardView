//
//  HIUIScatterCardViewDelegate.h
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIUIScatterCardView;
@protocol HIUIScatterCardViewDelegate <NSObject>

@optional
- (void)scatterCardView:(HIUIScatterCardView*)scatterCardView didSelectTileAtIndexPath:(NSIndexPath*)indexPath;
- (void)scatterCardView:(HIUIScatterCardView*)scatterCardView didExpandedWithCellCount:(NSInteger)numberOfCurrentCells;

@end
