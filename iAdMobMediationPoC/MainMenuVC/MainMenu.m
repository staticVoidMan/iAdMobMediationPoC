//
//  ViewController.m
//  iAdMobMediationPoC
//
//  Created by staticVoidMan on 19/01/15.
//  Copyright (c) 2015 staticVoidMan. All rights reserved.
//

#import "MainMenu.h"

#import "Banner_AdMobVC.h"
#import "Interstitial_AdMobVC.h"

#import "Banner_iAdVC.h"
#import "Interstitial_iAdVC.h"

@interface MainMenu () <Banner_AdMobVCDelegate, Banner_iAdVCDelegate, Interstitial_AdMobVCDelegate, Interstitial_iAdVCDelegate>
{
    IBOutlet NSLayoutConstraint *constraintAdMob;
    IBOutlet NSLayoutConstraint *constraintIAD;
    
    IBOutlet UIButton *btnToggleAdMobBanner;
    IBOutlet UIButton *btnRequestAdMobInterstitial;
    
    IBOutlet UIButton *btnToggleIAdBanner;
    IBOutlet UIButton *btnRequestIAdInterstitial;
    
    IBOutlet UIActivityIndicatorView *activityAdMobBanner;
    IBOutlet UIActivityIndicatorView *activityAdMobInterstitial;
    
    IBOutlet UIActivityIndicatorView *activityIAdBanner;
    IBOutlet UIActivityIndicatorView *activityIAdInterstitial;
    
    IBOutlet UIView *vwContainerAdMob;
    IBOutlet UIView *vwContainerIAd;
    
    Banner_AdMobVC *adMob;
    Banner_iAdVC *iAd;
}
@end

@implementation MainMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [btnToggleAdMobBanner setSelected:YES];
    [btnToggleIAdBanner setSelected:YES];
    
    [activityAdMobBanner stopAnimating];
    [activityAdMobInterstitial stopAnimating];
    [activityIAdBanner stopAnimating];
    [activityIAdInterstitial stopAnimating];
    
    [self btnToggleAdMobBanner_Act:btnToggleAdMobBanner];
    [self btnToggleIAdBanner_Act:btnToggleIAdBanner];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedBanner_AdMobVC"]) {
        adMob = segue.destinationViewController;
        [adMob setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"embedBanner_iAdVC"]) {
        iAd = segue.destinationViewController;
        [iAd setDelegate:self];
    }
}

#pragma mark - Button Methods
-(IBAction)btnToggleAdMobBanner_Act:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    
    if (sender.selected) {
        [self showBanner_AdMob];
    }
    else {
        [self hideBanner_AdMob];
    }
    
    [UIView animateWithDuration:0.27f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

-(IBAction)btnRequestAdMobInterstitial_Act:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [sender setSelected:YES];
    
    [[Interstitial_AdMobVC sharedInstance] startRequest];
    [[Interstitial_AdMobVC sharedInstance] setDelegate:self];
    
    [activityAdMobInterstitial startAnimating];
}

-(IBAction)btnToggleIAdBanner_Act:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    
    if (sender.selected) {
        [self showBanner_iAd];
    }
    else {
        [self hideBanner_iAd];
    }
    
    [UIView animateWithDuration:0.27f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

-(IBAction)btnRequestIAdInterstitial_Act:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [sender setSelected:YES];
    
    [[Interstitial_iAdVC sharedInstance] startRequest];
    [[Interstitial_iAdVC sharedInstance] setDelegate:self];
    
    [activityIAdInterstitial startAnimating];
}


#pragma mark - Helper Method
-(void)showBanner_iAd {
    constraintIAD.constant = 0;
    [activityIAdBanner stopAnimating];
}

-(void)hideBanner_iAd {
    constraintIAD.constant = -vwContainerIAd.bounds.size.height;
    [activityIAdBanner startAnimating];
}

-(void)showBanner_AdMob {
    constraintAdMob.constant = 0;
    [activityAdMobBanner stopAnimating];
}

-(void)hideBanner_AdMob {
    constraintAdMob.constant = -vwContainerAdMob.bounds.size.height;
    [activityAdMobBanner startAnimating];
}

#pragma mark - AdMob Banner Delegate
-(void)requestAdMobBannerCompletedWithSuccess:(BOOL)success {
    if (success && !btnToggleAdMobBanner.selected) {
        [self btnToggleAdMobBanner_Act:btnToggleAdMobBanner];
    }
}

#pragma mark - AdMob Interstitial Delegate
-(void)requestAdMobInterstitalCompletedWithSuccess:(BOOL)success {
    [btnRequestAdMobInterstitial setSelected:NO];
    [activityAdMobInterstitial stopAnimating];
}

#pragma mark - iAd Banner Delegate
-(void)requestIAdBannerCompletedWithSuccess:(BOOL)success {
    if (success && !btnToggleIAdBanner.selected) {
        [self btnToggleIAdBanner_Act:btnToggleIAdBanner];
    }
}

#pragma mark - iAd Interstitial Delegate
-(void)requestIADInterstitalCompletedWithSuccess:(BOOL)success {
    [btnRequestIAdInterstitial setSelected:NO];
    [activityIAdInterstitial stopAnimating];
}

@end
