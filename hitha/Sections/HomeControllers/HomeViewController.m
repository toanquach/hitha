//
//  HomeViewController.m
//  hitha
//
//  Created by Toan.Quach on 11/12/13.
//  Copyright (c) 2013 Toan.Quach. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    
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
@end
