//
//  MSMasterViewController.h
//  hitha
//
//  Created by Toan.Quach on 11/12/13.
//  Copyright (c) 2013 Toan.Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSNavigationPaneViewController.h"

typedef NS_ENUM(NSUInteger, MSPaneViewControllerType) {
    MSPaneViewControllerTypeAppearanceNone,
    MSPaneViewControllerTypeAppearanceParallax,
    MSPaneViewControllerTypeAppearanceZoom,
    MSPaneViewControllerTypeAppearanceFade,
    MSPaneViewControllerTypeControls,
    MSPaneViewControllerTypeMonospace,
    MSPaneViewControllerTypeCount
};

@interface MSMasterViewController : UIViewController

@property (nonatomic, assign) MSPaneViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSNavigationPaneViewController *navigationPaneViewController;

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType;

@end
