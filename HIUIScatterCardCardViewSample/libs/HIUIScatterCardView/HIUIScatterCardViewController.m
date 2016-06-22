//
//  HIUIScatterCardViewController.m
//  HIUIScatterCardCardViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "HIUIScatterCardViewController.h"

@implementation HIUIScatterCardViewController
@synthesize scatterCardView=_scatterCardView;

- (void)loadView {
    [super loadView];
    // Do any additional setup after loading the view, typically from a nib.
    
    _itemData = [[NSMutableArray alloc] init];
    
    _scatterCardView = [[HIUIScatterCardView alloc] initWithFrame:self.view.bounds layoutManager:self.layoutManager];
    self.scatterCardView.dataSource = self;
    self.scatterCardView.delegate = self;
    self.scatterCardView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.scatterCardView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ( self.isViewLoaded && self.view.window ) {
        [self.scatterCardView releaseAllViews];
    }
}

#pragma mark - properties

- (id<HIUIScatterCardViewLayoutManager>)layoutManager {
    NSAssert(NO, @"Should override this.");
    return nil;
}

#pragma mark - HIUIScatterCardView dataSource

- (void)scatterCardView:(HIUIScatterCardView *)scatterCardView shouldFetchDataWithDirection:(HIUIScatterCardViewExpandDirection)direction {
    NSAssert(NO, @"Should override this.");
}

- (UIView<HIUIScatterCardTile> *)scatterCardView:(HIUIScatterCardView *)scatterCardView tileAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"Should override this.");
    return nil;
}

- (NSInteger)numberOfDataInScatterCardView:(HIUIScatterCardView *)scatterCardView {
    return _itemData.count;
}

- (BOOL)canFetchMoreInScatterCardView:(HIUIScatterCardView *)scatterCardView {
    NSAssert(NO, @"Should override this.");
    return NO;
}

@end
