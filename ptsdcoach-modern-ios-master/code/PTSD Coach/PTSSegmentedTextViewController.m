//
//  PTSSegmentedTextViewController.m
//  PTSD Coach
//

#import "PTSSegmentedTextViewController.h"
#import "PTSContentLoader.h"
#import "PTSSegmentedTextView.h"

#pragma mark - Private Interface

@interface PTSSegmentedTextViewController ()

@property(nonatomic, weak) IBOutlet PTSSegmentedTextView *segmentedTextView;

@end

#pragma mark - Implementation

@implementation PTSSegmentedTextViewController

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  [self loadText];
}

#pragma mark - Public Methods

/**
 *  filename
 */
- (void)setFilename:(NSString *)filename {
  if (_filename != filename) {
    _filename = filename;

    [self loadText];
  }
}

#pragma mark - Private Methods

/**
 *  loadText
 */
- (void)loadText {
  if (self.filename) {
    PTSContentLoader *contentLoader = [PTSContentLoader contentLoaderWithFilename:self.filename];
    self.segmentedTextView.attributedText = contentLoader.attributedString;
  } else {
    [self.segmentedTextView clearText];
  }
}

@end
