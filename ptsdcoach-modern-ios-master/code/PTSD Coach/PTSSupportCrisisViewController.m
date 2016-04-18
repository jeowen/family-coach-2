//
//  PTSSupportCrisisViewController.m
//  PTSD Coach
//

#import "PTSSupportCrisisViewController.h"
#import "PTSContactsViewController.h"

#pragma mark - Private Interface

@interface PTSSupportCrisisViewController()

@property(nonatomic, strong) PTSContactsViewController *contactsViewController;

@end

@implementation PTSSupportCrisisViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
//- (void)viewDidLoad {
//  [super viewDidLoad];
//
//  UITextView *headerTextView = [[UITextView alloc] init];
//  headerTextView.editable = NO;
//  
//  NSURL *contentURL = [[NSBundle mainBundle] URLForResource:@"Support - Crisis Resources" withExtension:@"rtf"];
//  
//  if (contentURL != nil) {
//    NSError *error;
//    NSDictionary *docAttributes;
//    NSData *data = [NSData dataWithContentsOfURL:contentURL options:NSDataReadingUncached error:&error];
//    
//    if (data != nil) {
//      NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:data
//                                                                              options:@{ NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType }
//                                                                   documentAttributes:&docAttributes
//                                                                                error:nil];
//      
//      headerTextView.attributedText = attributedString;
//    }
//  }
//
//  self.tableView.tableHeaderView = headerTextView;
//  self.textView = headerTextView;
//  
//  [headerTextView sizeToFit];
//}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"ContactsEmbeddedSegue"]) {
    self.contactsViewController = segue.destinationViewController;
  }
}

#pragma mark - IBActions

/**
 *  handleAddBarButtonItemPressed
 */
- (IBAction)handleAddBarButtonItemPressed:(id)sender {
  [self.contactsViewController initiateAddContactExperience];
}

@end
