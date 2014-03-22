//
//  SLInfoViewController.h
//  Swipr
//
//  Created by Rachit Pokhrel on 3/17/14.
//  Copyright (c) 2014 Swipr Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString *infoURL;
@end
