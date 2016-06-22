//
//  HIUIScatterCardGuideView.h
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    HIUIScatterCardViewExpandDirectionNone = 0,
    HIUIScatterCardViewExpandDirectionTop = 1 << 0,
    HIUIScatterCardViewExpandDirectionLeft = 1 << 1,
    HIUIScatterCardViewExpandDirectionBottom = 1 << 2,
    HIUIScatterCardViewExpandDirectionRight = 1 << 3,
    
    HIUIScatterCardViewExpandDirectionTopLeft = (HIUIScatterCardViewExpandDirectionTop | HIUIScatterCardViewExpandDirectionLeft),
    HIUIScatterCardViewExpandDirectionTopRight = (HIUIScatterCardViewExpandDirectionTop | HIUIScatterCardViewExpandDirectionRight),
    HIUIScatterCardViewExpandDirectionBottomLeft = (HIUIScatterCardViewExpandDirectionBottom | HIUIScatterCardViewExpandDirectionLeft),
    HIUIScatterCardViewExpandDirectionBottomRight = (HIUIScatterCardViewExpandDirectionBottom | HIUIScatterCardViewExpandDirectionRight),
    
    HIUIScatterCardViewExpandDirectionAll = (HIUIScatterCardViewExpandDirectionTop | HIUIScatterCardViewExpandDirectionLeft | HIUIScatterCardViewExpandDirectionBottom | HIUIScatterCardViewExpandDirectionRight),
};
typedef NSInteger HIUIScatterCardViewExpandDirection;

enum {
    HIUIScatterCardViewExpandModeDisabled = 0,
    HIUIScatterCardViewExpandModeWaiting,
    HIUIScatterCardViewExpandModeLoading,
};
typedef NSInteger HIUIScatterCardViewExpandMode;

#define DEFAULT_LOADMORE_VIEW_HEIGHT        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 100.f : 60.f)

@interface HIUIScatterCardGuideView : UIView
{
    UIImageView* _topImageView;
    UIImageView* _topLeftImageView;
    UIImageView* _leftImageView;
    UIImageView* _bottomLeftImageView;
    UIImageView* _bottomImageView;
    UIImageView* _bottomRightImageView;
    UIImageView* _rightImageView;
    UIImageView* _topRightImageView;
}

@property (nonatomic, assign) HIUIScatterCardViewExpandMode expandMode;
@property (nonatomic, assign) HIUIScatterCardViewExpandDirection expandDirection;

@property (nonatomic, strong) UIImage* topImage;                // normal status
@property (nonatomic, strong) UIImage* cornerImage;              // top-left normal status image

@property (nonatomic, strong) NSArray* topAnimationImages;
@property (nonatomic, strong) NSArray* cornerAnimationImages;   // top-left

// total animation duration
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIColor* maskColor;

@end
