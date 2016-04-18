//
//  PTSToolMindfulLookingIntroViewController.m
//  PTSD Coach
//

#import "PTSToolMindfulLookingIntroViewController.h"
#import "PTSDatastore.h"
#import "PTSPhotosViewController.h"
#import "PTSTool.h"

static NSString *const PTSSegueIdentifierShowPhotos = @"ShowPhotosSegueIdentifier";

#pragma mark - Private Interface

@interface PTSToolMindfulLookingIntroViewController()

@property(nonatomic, weak) IBOutlet UIButton *beginButton;

@end

#pragma mark - Implementation

@implementation PTSToolMindfulLookingIntroViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.beginButton.enabled = ([PTSDatastore sharedDatastore].mindfulPhotos.count > 0);
}

/**
 *  prepareForSegue:sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierShowPhotos]) {
    PTSPhotosViewController *photosViewController = (PTSPhotosViewController *)segue.destinationViewController;
    photosViewController.photos = [PTSDatastore sharedDatastore].mindfulPhotos;
    photosViewController.navigationItem.title = self.tool.title;
    photosViewController.callbackBlock = ^(NSArray *photos) {
      [PTSDatastore sharedDatastore].mindfulPhotos = photos;
      self.beginButton.enabled = (photos.count > 0);
    };
  } else if ([segue.destinationViewController respondsToSelector:@selector(setTool:)]) {
    [segue.destinationViewController performSelector:@selector(setTool:) withObject:self.tool];
  }
}

@end
