//
//  HIScatterCardData.h
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIUIScatterCardTile.h"

@interface HIScatterCardData : NSObject

@property (nonatomic, strong) UIView<HIUIScatterCardTile>* tile;
@property (nonatomic, assign) CGPoint center;           // center point of the tile
@property (nonatomic, assign) NSUInteger index;

@end
