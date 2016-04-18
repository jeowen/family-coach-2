//
//  PTSApplicationDelegate.m
//  PTSD Coach
//

#import "PTSApplicationDelegate.h"
#import "PTSDatastore.h"

#pragma mark - Implementation

@implementation PTSApplicationDelegate

#pragma mark - UIApplicationDelegate Methods

/**
 *  application:didFinishLaunchingWithOptions
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  
  if ([PTSDatastore sharedDatastore].hasShownPreflightScreens) {
    [self showApplicationStoryboard:nil];
  } else {
    [self showPreflightStoryboard:nil];
  }

  [self.window makeKeyAndVisible];
  
  return YES;
}

/**
 *  applicationDidEnterBackground
 */

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[PTSDatastore sharedDatastore] save];
}

/**
 *  applicationWillTerminate
 */
- (void)applicationWillTerminate:(UIApplication *)application {
  [[PTSDatastore sharedDatastore] save];
}

#pragma mark - IBActions

/**
 *  showApplicationStoryboard
 */
- (IBAction)showApplicationStoryboard:(id)sender {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSApplicationStoryboard" bundle:nil];
  UIViewController *viewController = [storyboard instantiateInitialViewController];
  
  self.window.rootViewController = viewController;
  
  [PTSDatastore sharedDatastore].shownPreflightScreens = YES;
}

/**
 *  showPreflightStoryboard
 */
- (IBAction)showPreflightStoryboard:(id)sender {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSPreflightStoryboard" bundle:nil];
  UIViewController *viewController = [storyboard instantiateInitialViewController];
  
  self.window.rootViewController = viewController;
}

/**
 *  showSettingsStoryboard
 */
- (IBAction)showSettingsStoryboard:(id)sender {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PTSSettingsStoryboard" bundle:nil];
  UIViewController *viewController = [storyboard instantiateInitialViewController];
  
  [self.window.rootViewController showViewController:viewController sender:nil];
}

/**
 *  showHomeScreen
 */
- (IBAction)showHomeScreen:(id)sender {
  [self setTabBarControllerToSelectedIndex:0];
}

/**
 *  showLearnSection
 */
- (IBAction)showLearnSection:(id)sender {
  [self setTabBarControllerToSelectedIndex:1];
}

/**
 *  showTrackSymptomsSection
 */
- (IBAction)showTrackSymptomsSection:(id)sender {
  [self setTabBarControllerToSelectedIndex:2];
}

/**
 *  showManageSymptomsSection
 */
- (IBAction)showManageSymptomsSection:(id)sender {
  [self setTabBarControllerToSelectedIndex:3];
}

/**
 *  showSupportSection
 */
- (IBAction)showSupportSection:(id)sender {
  [self setTabBarControllerToSelectedIndex:4];
}

#pragma mark - Private Methods

/**
 *  setTabBarControllerToSelectedIndex
 */
- (void)setTabBarControllerToSelectedIndex:(NSUInteger)index {
  NSAssert([self.window.rootViewController isKindOfClass:[UITabBarController class]],
           @"Expected tab bar controller as window's root view controller.");
  
  UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
  tabBarController.selectedIndex = index;
}

@end
