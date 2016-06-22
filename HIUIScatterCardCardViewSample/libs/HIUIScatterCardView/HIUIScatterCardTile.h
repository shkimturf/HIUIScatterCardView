//
//  HIUIScatterCardTile.h
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HIUIScatterCardTile <NSObject>

+ (NSString*)reuseIdentifier;

@optional
- (void)initiateTile;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
