//
//  SampleLayoutManager.m
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "SampleLayoutManager.h"

@implementation SampleLayoutManager
@synthesize cellSize, tileSize, initialPanelLevel;

- (instancetype)init {
    self = [super init];
    if (self) {
        if ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ) {
            cellSize = CGSizeMake(192.f, 192.f);
            tileSize = CGSizeMake(114.f, 154.f);
            
            initialPanelLevel = 4;
        } else {
            cellSize = CGSizeMake(164.f, 164.f);
            tileSize = CGSizeMake(96.f, 130.f);
            
            initialPanelLevel = 3;
        }
    }
    
    return self;
}

@end
