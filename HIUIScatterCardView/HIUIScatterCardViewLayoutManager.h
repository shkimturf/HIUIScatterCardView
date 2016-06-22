//
//  HIUIScatterCardViewLayoutManager.h
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HIUIScatterCardViewLayoutManager <NSObject>

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGSize tileSize;

@property (nonatomic, assign) NSUInteger initialPanelLevel;

@end
