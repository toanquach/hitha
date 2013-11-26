//
//  HomeViewController.m
//  hitha
//
//  Created by Toan.Quach on 11/12/13.
//  Copyright (c) 2013 Toan.Quach. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImage+BlurredFrame.h"

@interface HomeViewController ()
{
    IBOutlet UIImageView *blurImageView;
    
    IBOutlet UIScrollView *mainScrollView;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *img = blurImageView.image;
    CGRect frame = CGRectMake(0, 0, img.size.width, img.size.height - 400);
    img = [img applyLightEffectAtFrame:frame];
    blurImageView.image = img;
    
    mainScrollView.contentSize = CGSizeMake(320*3, mainScrollView.frame.size.height);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, mainScrollView.frame.size.height)];
    view.backgroundColor = [UIColor redColor];
    [mainScrollView addSubview:view];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, mainScrollView.frame.size.height)];
    view.backgroundColor = [UIColor blackColor];
    [mainScrollView addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"settingSegue" sender:self];
}
- (void)viewDidUnload {
    blurImageView = nil;
    mainScrollView = nil;
    [super viewDidUnload];
}
@end
