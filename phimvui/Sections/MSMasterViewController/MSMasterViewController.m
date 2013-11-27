//
//  MSMasterViewController.m
//  hitha
//
//  Created by Toan.Quach on 11/12/13.
//  Copyright (c) 2013 Toan.Quach. All rights reserved.
//

#import "MSMasterViewController.h"
#import "DataReader.h"

NSString * const MSMasterViewControllerCellReuseIdentifier = @"MSMasterViewControllerCellReuseIdentifier";

typedef NS_ENUM(NSUInteger, MSMasterViewControllerTableViewSectionType)
{
    MSMasterViewControllerTableViewSectionTypeAppearanceTypes,
    MSMasterViewControllerTableViewSectionTypeControls,
    MSMasterViewControllerTableViewSectionTypeAbout,
    MSMasterViewControllerTableViewSectionTypeCount
};

@interface MSMasterViewController () <MSNavigationPaneViewControllerDelegate>
{
    IBOutlet UITableView *myTableView;
    NSMutableDictionary *dictItems;
}

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;
#if defined(STORYBOARD)
@property (nonatomic, strong) NSDictionary *paneViewControllerIdentifiers;
#else
@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
#endif
@property (nonatomic, strong) NSDictionary *paneViewControllerAppearanceTypes;
@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealBarButtonItem;

- (void)updateNavigationPaneForOpenDirection:(MSNavigationPaneOpenDirection)openDirection;
- (void)navigationPaneRevealBarButtonItemTapped:(id)sender;
- (void)navigationPaneStateBarButtonItemTapped:(id)sender;

@end

@implementation MSMasterViewController

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationPaneViewController.delegate = self;
    
    // Default to the "None" appearance type
    [self transitionToViewController:MSPaneViewControllerTypeAppearanceNone];
}

#pragma mark - MSMasterViewController

- (void)initialize
{
    dictItems = [NSMutableDictionary dictionaryWithDictionary:[DataReader dictReadDataWithKey:kData_Menu]];
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerTitles =
  @{
      @(MSPaneViewControllerTypeAppearanceNone)     : @"None",
      @(MSPaneViewControllerTypeAppearanceParallax) : @"Parallax",
      @(MSPaneViewControllerTypeAppearanceZoom)     : @"Zoom",
      @(MSPaneViewControllerTypeAppearanceFade)     : @"Fade",
      @(MSPaneViewControllerTypeControls)           : @"Controls",
      @(MSPaneViewControllerTypeMonospace)          : @"Monospace Ltd."
    };
    
#if defined(STORYBOARD)
    self.paneViewControllerIdentifiers =
  @{
       @(MSPaneViewControllerTypeAppearanceNone)        : @"homeViewController",
       @(MSPaneViewControllerTypeAppearanceParallax)    : @"homeViewController",
       @(MSPaneViewControllerTypeAppearanceZoom)        : @"homeViewController",
       @(MSPaneViewControllerTypeAppearanceFade)        : @"homeViewController",
       @(MSPaneViewControllerTypeControls)              : @"homeViewController",
       @(MSPaneViewControllerTypeMonospace)             : @"homeViewController",
    };
#else
    self.paneViewControllerClasses =
    @{
       @(MSPaneViewControllerTypeAppearanceNone)    : MSExampleTableViewController.class,
       @(MSPaneViewControllerTypeAppearanceParallax): MSExampleTableViewController.class,
       @(MSPaneViewControllerTypeAppearanceZoom)    : MSExampleTableViewController.class,
       @(MSPaneViewControllerTypeAppearanceFade)    : MSExampleTableViewController.class,
       @(MSPaneViewControllerTypeControls)          : MSExampleControlsViewController.class,
       @(MSPaneViewControllerTypeMonospace)         : MSMonospaceViewController.class
    };
#endif
    
    self.paneViewControllerAppearanceTypes =
  @{
       @(MSPaneViewControllerTypeAppearanceNone)     : @(MSNavigationPaneAppearanceTypeNone),
       @(MSPaneViewControllerTypeAppearanceParallax) : @(MSNavigationPaneAppearanceTypeParallax),
       @(MSPaneViewControllerTypeAppearanceZoom)     : @(MSNavigationPaneAppearanceTypeZoom),
       @(MSPaneViewControllerTypeAppearanceFade)     : @(MSNavigationPaneAppearanceTypeFade),
    };
    
    self.sectionTitles =
  @{
       @(MSMasterViewControllerTableViewSectionTypeAppearanceTypes) : @"Appearance Types",
       @(MSMasterViewControllerTableViewSectionTypeControls)        : @"Controls",
       @(MSMasterViewControllerTableViewSectionTypeAbout)           : @"About",
    };
    
    self.tableViewSectionBreaks =
  @[
        @(MSPaneViewControllerTypeControls),
        @(MSPaneViewControllerTypeMonospace),
        @(MSPaneViewControllerTypeCount)
    ];
}

- (MSPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    MSPaneViewControllerType paneViewControllerType;
    if (indexPath.section == 0)
    {
        paneViewControllerType = indexPath.row;
    }
    else
    {
        paneViewControllerType = ([self.tableViewSectionBreaks[(indexPath.section - 1)] integerValue] + indexPath.row);
    }
    
    NSAssert(paneViewControllerType < MSPaneViewControllerTypeCount, @"Invalid Index Path");
    return paneViewControllerType;
}

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType
{
    if (paneViewControllerType == self.paneViewControllerType)
    {
        [self.navigationPaneViewController setPaneState:MSNavigationPaneStateClosed animated:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.navigationPaneViewController.paneViewController != nil;
    
#if defined(STORYBOARD)
    UIViewController *paneViewController = [self.navigationPaneViewController.storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
#else
    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    NSParameterAssert([paneViewControllerClass isSubclassOfClass:UIViewController.class]);
    UIViewController *paneViewController = (UIViewController *)[[paneViewControllerClass alloc] init];
#endif
    
    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    self.paneRevealBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigationPaneRevealBarButtonItemTapped:)];
    paneViewController.navigationItem.leftBarButtonItem = self.paneRevealBarButtonItem;
    
    self.paneStateBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(navigationPaneStateBarButtonItemTapped:)];
    //paneViewController.navigationItem.rightBarButtonItem = self.paneStateBarButtonItem;
    
    // Update pane state button titles
    [self updateNavigationPaneForOpenDirection:self.navigationPaneViewController.openDirection];
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [self.navigationPaneViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

- (void)updateNavigationPaneForOpenDirection:(MSNavigationPaneOpenDirection)openDirection
{
    if (openDirection == MSNavigationPaneOpenDirectionLeft)
    {
        self.paneStateBarButtonItem.title = @"Top Reveal";
        self.navigationPaneViewController.openStateRevealWidth = 265.0;
        self.navigationPaneViewController.paneViewSlideOffAnimationEnabled = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    }
    else
    {
        self.paneStateBarButtonItem.title = @"Left Reveal";
        self.navigationPaneViewController.openStateRevealWidth = myTableView.contentSize.height;
        self.navigationPaneViewController.paneViewSlideOffAnimationEnabled = NO;
    }
}

- (void)navigationPaneRevealBarButtonItemTapped:(id)sender
{
    [self.navigationPaneViewController setPaneState:MSNavigationPaneStateOpen animated:YES completion:nil];
}

- (void)navigationPaneStateBarButtonItemTapped:(id)sender
{
    if (self.navigationPaneViewController.openDirection == MSNavigationPaneOpenDirectionLeft)
    {
        self.navigationPaneViewController.openDirection = MSNavigationPaneOpenDirectionTop;
    }
    else
    {
        self.navigationPaneViewController.openDirection =  MSNavigationPaneOpenDirectionLeft;
    }
    [self updateNavigationPaneForOpenDirection:self.navigationPaneViewController.openDirection];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dictItems.allKeys count];
    //return MSMasterViewControllerTableViewSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dictItems objectForKey:[dictItems.allKeys objectAtIndex:section]] count];
    
//    if (section == 0)
//    {
//        return [self.tableViewSectionBreaks[section] integerValue];
//    }
//    else
//    {
//        return ([self.tableViewSectionBreaks[section] integerValue] - [self.tableViewSectionBreaks[(section - 1)] integerValue]);
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [dictItems.allKeys objectAtIndex:section];
    //return self.sectionTitles[@(section)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MSMasterViewControllerCellReuseIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MSMasterViewControllerCellReuseIdentifier];
    }
    NSArray *arr = [dictItems objectForKey:[dictItems.allKeys objectAtIndex:indexPath.section]];
    NSDictionary *dict = [arr objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"name"];
    
    //MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    //cell.textLabel.text = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    // Add a checkmark to the current pane type
//    if (self.paneViewControllerAppearanceTypes[@(paneViewControllerType)] && (self.navigationPaneViewController.appearanceType == [self.paneViewControllerAppearanceTypes[@(paneViewControllerType)] unsignedIntegerValue]))
//    {
//        cell.textLabel.text = [NSString stringWithFormat:@"✓ %@", cell.textLabel.text];
//    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    [self transitionToViewController:paneViewControllerType];
    if (self.paneViewControllerAppearanceTypes[@(paneViewControllerType)])
    {
        self.navigationPaneViewController.appearanceType = [self.paneViewControllerAppearanceTypes[@(paneViewControllerType)] unsignedIntegerValue];
        // Update row titles
        [myTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MSNavigationPaneViewControllerDelegate

- (void)navigationPaneViewController:(MSNavigationPaneViewController *)navigationPaneViewController didUpdateToPaneState:(MSNavigationPaneState)state
{
    // Ensure that the pane's table view can scroll to top correctly
    myTableView.scrollsToTop = (state == MSNavigationPaneStateOpen);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    myTableView = nil;
    [super viewDidUnload];
}
@end
