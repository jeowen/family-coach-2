//
//  PTSToolMindfulListeningViewController.m
//  PTSD Coach
//

#import "PTSToolMindfulListeningViewController.h"
#import "PTSSongPlayerViewController.h"

static NSString *const PTSSegueIdentifierEmbedSongPlayer = @"EmbedSongPlayerSegue";

#pragma mark - Private Interface

@interface PTSToolMindfulListeningViewController ()

@property(nonatomic, weak) IBOutlet UIStackView *introStackView;
@property(nonatomic, weak) IBOutlet UIView *myEnvironmentContainerView;
@property(nonatomic, weak) IBOutlet UIView *mySongsContainerView;

@end

#pragma mark - Implementation

@implementation PTSToolMindfulListeningViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.introStackView.hidden = NO;
  self.myEnvironmentContainerView.hidden = YES;
  self.mySongsContainerView.hidden = YES;
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierEmbedSongPlayer]) {
    PTSSongPlayerViewController *songPlayerViewController = (PTSSongPlayerViewController *)segue.destinationViewController;
    songPlayerViewController.embeddedInContainerView = YES;
    songPlayerViewController.listSource = PTSSongPlayerListSourceMindfulListening;
    songPlayerViewController.songPickerViewTitle = NSLocalizedString(@"Mindfulness Songs", nil);
  }
}

#pragma mark - IBActions

/**
 *  handleMyEnvironmentButtonPressed
 */
- (IBAction)handleMyEnvironmentButtonPressed:(id)sender {
  self.introStackView.hidden = YES;
  self.myEnvironmentContainerView.hidden = NO;
  self.mySongsContainerView.hidden = YES;
}

/**
 *  handleMySongsButtonPressed
 */
- (IBAction)handleMySongsButtonPressed:(id)sender {
  self.introStackView.hidden = YES;
  self.myEnvironmentContainerView.hidden = YES;
  self.mySongsContainerView.hidden = NO;
}

@end
