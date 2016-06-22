//
//  HIUIScatterCardGuideView.m
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "HIUIScatterCardGuideView.h"
#import "UIImage+HIScatterCard.h"
#import "NSArray+HIScatterCard.h"

@interface HIUIScatterCardGuideView ()
@property (nonatomic, assign) BOOL animating;
@end

@implementation HIUIScatterCardGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self _setUp];
}

#pragma mark - properties

- (void)setExpandMode:(HIUIScatterCardViewExpandMode)expandMode {
    _expandMode = expandMode;
    
    _topImageView.hidden = (HIUIScatterCardViewExpandModeDisabled == self.expandMode);
    _topLeftImageView.hidden = (HIUIScatterCardViewExpandModeDisabled == self.expandMode);
    _leftImageView.hidden = (HIUIScatterCardViewExpandModeDisabled == self.expandMode);
    _bottomLeftImageView.hidden = (HIUIScatterCardViewExpandModeDisabled == self.expandMode);
    _bottomImageView.hidden = (HIUIScatterCardViewExpandModeDisabled == self.expandMode);
    _bottomRightImageView.hidden = (HIUIScatterCardViewExpandModeDisabled == self.expandMode);
    _rightImageView.hidden = (HIUIScatterCardViewExpandModeDisabled == self.expandMode);
    _topRightImageView.hidden = (HIUIScatterCardViewExpandModeDisabled == self.expandMode);
    
    switch ( self.expandMode ) {
        case HIUIScatterCardViewExpandModeWaiting:
            self.animating = NO;
            break;
        case HIUIScatterCardViewExpandModeDisabled:
            self.animating = NO;
            break;
        case HIUIScatterCardViewExpandModeLoading:
            self.animating = YES;
            break;
    }
}

- (void)setExpandDirection:(HIUIScatterCardViewExpandDirection)expandDirection {
    _expandDirection = expandDirection;
    
    if ( HIUIScatterCardViewExpandModeLoading != self.expandMode ) {
        return;
    }
    
    _topImageView.hidden = YES;
    _topLeftImageView.hidden = YES;
    _leftImageView.hidden = YES;
    _bottomLeftImageView.hidden = YES;
    _bottomImageView.hidden = YES;
    _bottomRightImageView.hidden = YES;
    _rightImageView.hidden = YES;
    _topRightImageView.hidden = YES;
    
    if ( self.expandDirection & HIUIScatterCardViewExpandDirectionTop ) {
        _topImageView.hidden = NO;
    }
    if ( self.expandDirection & HIUIScatterCardViewExpandDirectionLeft ) {
        _leftImageView.hidden = NO;
    }
    if ( self.expandDirection & HIUIScatterCardViewExpandDirectionBottom ) {
        _bottomImageView.hidden = NO;
    }
    if ( self.expandDirection & HIUIScatterCardViewExpandDirectionRight ) {
        _rightImageView.hidden = NO;
    }
    if ( self.expandDirection & HIUIScatterCardViewExpandDirectionTop && self.expandDirection & HIUIScatterCardViewExpandDirectionLeft ) {
        _topLeftImageView.hidden = NO;
    }
    if ( self.expandDirection & HIUIScatterCardViewExpandDirectionBottom && self.expandDirection & HIUIScatterCardViewExpandDirectionLeft ) {
        _bottomLeftImageView.hidden = NO;
    }
    if ( self.expandDirection & HIUIScatterCardViewExpandDirectionBottom && self.expandDirection & HIUIScatterCardViewExpandDirectionRight ) {
        _bottomRightImageView.hidden = NO;
    }
    if ( self.expandDirection & HIUIScatterCardViewExpandDirectionTop && self.expandDirection & HIUIScatterCardViewExpandDirectionRight ) {
        _topRightImageView.hidden = NO;
    }
}

- (void)setTopImage:(UIImage *)topImage {
    _topImage = topImage;
    
    _topImageView.image = self.topImage;
    _leftImageView.image = [self.topImage rotateUIImageWithorientation:UIImageOrientationLeft];
    _bottomImageView.image = [self.topImage rotateUIImageWithorientation:UIImageOrientationDown];
    _rightImageView.image = [self.topImage rotateUIImageWithorientation:UIImageOrientationRight];
}

- (void)setCornerImage:(UIImage *)cornerImage {
    _cornerImage = cornerImage;
    
    _topLeftImageView.image = self.cornerImage;
    _bottomLeftImageView.image = [self.cornerImage rotateUIImageWithorientation:UIImageOrientationLeft];
    _bottomRightImageView.image = [self.cornerImage rotateUIImageWithorientation:UIImageOrientationDown];
    _topRightImageView.image = [self.cornerImage rotateUIImageWithorientation:UIImageOrientationRight];
}

- (void)setTopAnimationImages:(NSArray *)topAnimationImages {
    _topAnimationImages = topAnimationImages;
    
    _topImageView.animationImages = self.topAnimationImages;
    
    _leftImageView.animationImages = [self.topAnimationImages mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        UIImage* image = obj;
        return [image rotateUIImageWithorientation:UIImageOrientationLeft];
    }];
    
    _bottomImageView.animationImages = [self.topAnimationImages mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        UIImage* image = obj;
        return [image rotateUIImageWithorientation:UIImageOrientationDown];
    }];
    
    _rightImageView.animationImages = [self.topAnimationImages mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        UIImage* image = obj;
        return [image rotateUIImageWithorientation:UIImageOrientationRight];
    }];
}

- (void)setCornerAnimationImages:(NSArray *)cornerAnimationImages {
    _cornerAnimationImages = cornerAnimationImages;
    
    _topLeftImageView.animationImages = self.cornerAnimationImages;
    
    _bottomLeftImageView.animationImages = [self.cornerAnimationImages mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        UIImage* image = obj;
        return [image rotateUIImageWithorientation:UIImageOrientationLeft];
    }];
    
    _bottomRightImageView.animationImages = [self.cornerAnimationImages mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        UIImage* image = obj;
        return [image rotateUIImageWithorientation:UIImageOrientationDown];
    }];
    
    _topRightImageView.animationImages = [self.cornerAnimationImages mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
        UIImage* image = obj;
        return [image rotateUIImageWithorientation:UIImageOrientationRight];
    }];
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    _animationDuration = animationDuration;
    
    _topImageView.animationDuration = animationDuration;
    _topLeftImageView.animationDuration = animationDuration;
    _leftImageView.animationDuration = animationDuration;
    _bottomLeftImageView.animationDuration = animationDuration;
    _bottomImageView.animationDuration = animationDuration;
    _bottomRightImageView.animationDuration = animationDuration;
    _rightImageView.animationDuration = animationDuration;
    _topRightImageView.animationDuration = animationDuration;
}

- (void)setAnimating:(BOOL)animating {
    _animating = animating;
    
    if ( self.animating ) {
        [_topImageView startAnimating];
        [_topLeftImageView startAnimating];
        [_leftImageView startAnimating];
        [_bottomLeftImageView startAnimating];
        [_bottomImageView startAnimating];
        [_bottomRightImageView startAnimating];
        [_rightImageView startAnimating];
        [_topRightImageView startAnimating];
    } else {
        [_topImageView stopAnimating];
        [_topLeftImageView stopAnimating];
        [_leftImageView stopAnimating];
        [_bottomLeftImageView stopAnimating];
        [_bottomImageView stopAnimating];
        [_bottomRightImageView stopAnimating];
        [_rightImageView stopAnimating];
        [_topRightImageView stopAnimating];
    }
}

#pragma mark - private functions

- (void)_setUp {
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, -DEFAULT_LOADMORE_VIEW_HEIGHT, CGRectGetWidth(self.bounds), DEFAULT_LOADMORE_VIEW_HEIGHT)];
    _topImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth);
    _topImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_topImageView];
    
    _topLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-DEFAULT_LOADMORE_VIEW_HEIGHT, -DEFAULT_LOADMORE_VIEW_HEIGHT, DEFAULT_LOADMORE_VIEW_HEIGHT, DEFAULT_LOADMORE_VIEW_HEIGHT)];
    _topLeftImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
    [self addSubview:_topLeftImageView];
    
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-DEFAULT_LOADMORE_VIEW_HEIGHT, 0.f, DEFAULT_LOADMORE_VIEW_HEIGHT, CGRectGetHeight(self.bounds))];
    _leftImageView.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight);
    _leftImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_leftImageView];
    
    _bottomLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-DEFAULT_LOADMORE_VIEW_HEIGHT, CGRectGetHeight(self.bounds), DEFAULT_LOADMORE_VIEW_HEIGHT, DEFAULT_LOADMORE_VIEW_HEIGHT)];
    _bottomLeftImageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin);
    [self addSubview:_bottomLeftImageView];
    
    _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), DEFAULT_LOADMORE_VIEW_HEIGHT)];
    _bottomImageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
    _bottomImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_bottomImageView];
    
    _bottomRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds), DEFAULT_LOADMORE_VIEW_HEIGHT, DEFAULT_LOADMORE_VIEW_HEIGHT)];
    _bottomRightImageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    [self addSubview:_bottomRightImageView];
    
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0.f, DEFAULT_LOADMORE_VIEW_HEIGHT, CGRectGetHeight(self.bounds))];
    _rightImageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight);
    _rightImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_rightImageView];
    
    _topRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), -DEFAULT_LOADMORE_VIEW_HEIGHT, DEFAULT_LOADMORE_VIEW_HEIGHT, DEFAULT_LOADMORE_VIEW_HEIGHT)];
    _topRightImageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin);
    [self addSubview:_topRightImageView];
    
    self.clipsToBounds = NO;
}

@end
