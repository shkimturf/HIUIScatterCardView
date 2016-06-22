//
//  HIScatterCardData.m
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "HIScatterCardData.h"

@implementation HIScatterCardData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.center = CGPointZero;
        self.index = NSNotFound;
    }
    
    return self;
}

@end
