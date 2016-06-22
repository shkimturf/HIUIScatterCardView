//
//  HIUIScatterCardViewController.h
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HIUIScatterCardView.h"

@interface HIUIScatterCardViewController : UIViewController <HIUIScatterCardViewDataSource, HIUIScatterCardViewDelegate>
{
    HIUIScatterCardView* _scatterCardView;
    
    NSMutableArray* _itemData;
}

@property (nonatomic, strong, readonly) id<HIUIScatterCardViewLayoutManager> layoutManager;
@property (nonatomic, strong, readonly) HIUIScatterCardView* scatterCardView;

@end
