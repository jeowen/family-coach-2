//
//  PTSEULAViewController.m
//  PTSD Coach
//

#import "PTSEULAViewController.h"
#import "PTSContentLoader.h"

@interface PTSEULAViewController ()

@property(nonatomic, weak) IBOutlet UILabel *contentLabel;

@end

#pragma mark - Implementation

@implementation PTSEULAViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  PTSContentLoader *contentLoader = [PTSContentLoader contentLoaderWithFilename:@"Preflight - EULA.rtf"];
  self.contentLabel.attributedText = contentLoader.attributedString;
}

@end
