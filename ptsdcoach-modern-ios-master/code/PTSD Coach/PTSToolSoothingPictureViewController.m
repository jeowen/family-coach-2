//
//  PTSToolSoothingPictureViewController.m
//  PTSD Coach
//

#import "PTSToolSoothingPictureViewController.h"
#import "PTSDatastore.h"
#import "PTSPhotosViewController.h"
#import "PTSRandomContentProvider.h"
#import "PTSTool.h"

static NSString *const PTSSegueIdentifierShowPhotos = @"ShowPhotosSegueIdentifier";

#pragma mark - Private Interface

@interface PTSToolSoothingPictureViewController()

@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, weak) IBOutlet UILabel *noImagesLabel;

@property(nonatomic, strong) PTSRandomContentProvider *randomContentProvider;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

#pragma mark - Implementation

@implementation PTSToolSoothingPictureViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  NSArray *photos = [PTSDatastore sharedDatastore].soothingPhotos;
  if (!photos) {
    photos = @[];
  }
  
  self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTappedGesture:)];
  self.tapGestureRecognizer.numberOfTapsRequired = 1;
  
  self.imageView.userInteractionEnabled = YES;
  [self.imageView addGestureRecognizer:self.tapGestureRecognizer];
  
  [self invalidateLayoutAndReloadWithPhotos:photos];
}

/**
 *  prepareForSegue:sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierShowPhotos]) {
    PTSPhotosViewController *photosViewController = (PTSPhotosViewController *)segue.destinationViewController;
    photosViewController.photos = self.randomContentProvider.contentItems;
    photosViewController.navigationItem.title = self.tool.title;
    photosViewController.callbackBlock = ^(NSArray *photos) {
      [PTSDatastore sharedDatastore].soothingPhotos = photos;
      [self invalidateLayoutAndReloadWithPhotos:photos];
    };
  }
}

#pragma mark - Action Handlers

/**
 *  handleImageViewTappedGesture
 */
- (void)handleImageViewTappedGesture:(UITapGestureRecognizer *)gesture {
  [UIView transitionWithView:self.imageView
                    duration:0.25
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    self.imageView.image = [self.randomContentProvider nextContentItem];
                  } completion:nil];
}

#pragma mark - Private Methods

/**
 *  invalidateLayoutAndReloadWithPhotos
 */
- (void)invalidateLayoutAndReloadWithPhotos:(NSArray *)photos {
  self.randomContentProvider = [[PTSRandomContentProvider alloc] initWithContentItems:photos];
  self.imageView.image = [self.randomContentProvider nextContentItem];

  self.noImagesLabel.hidden = (self.randomContentProvider.itemCount > 0);
  self.imageView.hidden = (self.randomContentProvider.itemCount == 0);
}

@end
