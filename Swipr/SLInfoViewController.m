//
//  SLInfoViewController.m
//  Swipr
//
//  Created by Rachit Pokhrel on 3/17/14.
//  Copyright (c) 2014 Swipr Limited. All rights reserved.
//

#import "SLInfoViewController.h"

@interface SLInfoViewController ()<UIWebViewDelegate>
- (IBAction)dismiss:(id)sender;

@end

@implementation SLInfoViewController

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
    NSURL *url = [NSURL URLWithString:self.infoURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webview.delegate = self;
    [self.webview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
