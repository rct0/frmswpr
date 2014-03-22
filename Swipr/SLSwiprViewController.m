//
//  SLSwiprViewController.m
//  Swipr
//
//  Created by Rachit Pokhrel on 3/17/14.
//  Copyright (c) 2014 Swipr Limited. All rights reserved.
//

#import "SLSwiprViewController.h"
#import "SLSwiprSession.h"
#import "Ad.h"
#import "Reachability.h"
#import "SLInfoViewController.h"
#import "SLSwiprDynamicInteractor.h"
#import <MessageUI/MessageUI.h>

@interface SLSwiprViewController ()<UIGestureRecognizerDelegate, MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) Ad *ad;
@property (strong, nonatomic) IBOutlet UIImageView *adImage;
@property (strong, nonatomic) NSDictionary *appInfo;
@property (assign, nonatomic) NSUInteger currentIndex;

@end

@implementation SLSwiprViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


-(void)showAdswithAppInfo:(NSDictionary*)appInfo onParentViewController:(UIViewController*)viewController
{
    self.appInfo = appInfo;
    SLSwiprDynamicInteractor *interactor = [[SLSwiprDynamicInteractor alloc] initWithParentViewController:viewController];
    [interactor presentController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAd:YES forIndex:0];
}

-(BOOL)isNetworkAvailable
{
    Reachability *rechability = [Reachability reachabilityForInternetConnection];
    NetworkStatus network = [rechability currentReachabilityStatus];
    if (network == NotReachable){
        return NO;
    }
    else
        return YES;
}

-(void)loadAd:(BOOL)load forIndex:(NSUInteger)adIndex{
    if (![self isNetworkAvailable])
    {
        
    }else{
        [SLSwiprSession loadAds:load WithAppInfo:self.appInfo enumerateAds:^(id ad, NSUInteger index, BOOL *stop){
            if (adIndex == index){
                self.ad = ad;
                NSLog(@"ad:%@",ad);
                [self.ad loadImage:^(NSData *data, NSError *error){
                    self.adImage.image = [UIImage imageWithData:data];
                }];
                *stop = YES;
            }
        }];
    }
    self.currentIndex = adIndex;
}

-(NSUInteger)updateIndex
{
    return self.currentIndex > 9 ? 0 : self.currentIndex + 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)numberOfMatchesForPattern:(NSString*)pattern
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.ad.redirectURL options:0 range:NSMakeRange(0, [self.ad.redirectURL length])];
    return numberOfMatches;
}
- (IBAction)tapGesture:(id)sender {
    [self loadAd:NO forIndex:[self updateIndex]];
}

- (IBAction)rightSwipeGesture:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [SLSwiprSession clearSession];
}

- (IBAction)leftSwipeGesture:(id)sender {
    if ([self numberOfMatchesForPattern:@"tel:"] > 0)
        [self call];
    else if ([self numberOfMatchesForPattern:@"sms:"] > 0)
        [self showSMS];
    else if ([self numberOfMatchesForPattern:@"http:"] > 0)
        [self performSegueWithIdentifier:@"showInfo" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showInfo"])
    {
        NSString *url = self.ad.redirectURL;
        SLInfoViewController *infoVC = segue.destinationViewController;
        infoVC.infoURL = url;
        SLSwiprDynamicInteractor *interactor = [[SLSwiprDynamicInteractor alloc] initWithParentViewController:self];
        [interactor presentController:infoVC];
    }
}

#pragma mark Phone - showing phone.app
-(void)call
{
    NSString *cleanedString = [[self.ad.redirectURL componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:telURL];
}

#pragma mark SMS- showing and delegates
-(void)showSMS
{
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:@[self.ad.redirectURL]];
    [messageController setBody:@"send this sms"];
    SLSwiprDynamicInteractor *interactor = [[SLSwiprDynamicInteractor alloc] initWithParentViewController:self];
    [interactor presentController:messageController];
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
