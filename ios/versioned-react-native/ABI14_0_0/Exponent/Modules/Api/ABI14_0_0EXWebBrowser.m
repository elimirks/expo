// Copyright 2015-present 650 Industries. All rights reserved.

#import <ReactABI14_0_0/ABI14_0_0RCTUtils.h>
#import <SafariServices/SafariServices.h>
#import "ABI14_0_0EXWebBrowser.h"
#import "ABI14_0_0EXUnversioned.h"

@interface ABI14_0_0EXWebBrowser () <SFSafariViewControllerDelegate>

@end

NSString *ABI14_0_0EXWebBrowserErrorCode = @"ABI14_0_0EXWebBrowser";


@implementation ABI14_0_0EXWebBrowser
{
  ABI14_0_0RCTPromiseResolveBlock _redirectResolve;
  ABI14_0_0RCTPromiseRejectBlock _redirectReject;
  UIStatusBarStyle _initialStatusBarStyle;
}

ABI14_0_0RCT_EXPORT_MODULE(ExponentWebBrowser)

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

ABI14_0_0RCT_EXPORT_METHOD(openBrowserAsync:(NSString *)authURL
                          resolver:(ABI14_0_0RCTPromiseResolveBlock)resolve
                          rejecter:(ABI14_0_0RCTPromiseRejectBlock)reject)
{
  if (_redirectResolve) {
    reject(ABI14_0_0EXWebBrowserErrorCode, @"Another WebBrowser is already being presented.", nil);
    return;
  }
  _redirectReject = reject;
  _redirectResolve = resolve;
  _initialStatusBarStyle = ABI14_0_0RCTSharedApplication().statusBarStyle;
  [ABI14_0_0RCTSharedApplication() setStatusBarStyle:UIStatusBarStyleDefault animated: YES];
  
  if ([SFSafariViewController class]) {
    // Safari View Controller to authorize request
    NSURL *url = [[NSURL alloc] initWithString:authURL];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:NO];
    safariVC.delegate = self;

    // This is a hack to present the SafariViewController modally
    UINavigationController *safariHackVC = [[UINavigationController alloc] initWithRootViewController:safariVC];
    [safariHackVC setNavigationBarHidden:true animated:false];
    [ABI14_0_0RCTPresentedViewController() presentViewController:safariHackVC animated:true completion:nil];
  } else {
    // Opens Safari Browser when SFSafariViewController is not available (iOS 8)
    [ABI14_0_0RCTSharedApplication() openURL:[NSURL URLWithString:authURL]];
  }
}

ABI14_0_0RCT_EXPORT_METHOD(dismissBrowser) {
  [ABI14_0_0RCTPresentedViewController() dismissViewControllerAnimated:true completion:^{
    _redirectResolve(@{
                       @"type": @"dismissed",
                       });
    [self flowDidFinish];
  }];
}


/**
 * Called when the user dismisses the SFVC without logging in.
 */
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
  _redirectResolve(@{
    @"type": @"cancel",
  });
  [self flowDidFinish];
}

-(void)flowDidFinish
{
  [ABI14_0_0RCTSharedApplication() setStatusBarStyle:_initialStatusBarStyle animated:YES];
  _redirectResolve = nil;
  _redirectReject = nil;
}

@end
