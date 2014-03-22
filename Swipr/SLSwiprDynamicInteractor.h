//
//  TLMenuDynamicInteractor.h
//  UIViewController-Transitions-Example
//
//  Created by Ash Furrow on 2013-07-23.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSwiprDynamicInteractor : UIPercentDrivenInteractiveTransition 

-(id)initWithParentViewController:(UIViewController *)viewController;

@property (nonatomic, readonly) UIViewController *parentViewController;

-(void)presentController:(UIViewController*)adViewController;

@end
