//
//  PTSToolConnectOthersViewController.m
//  PTSD Coach
//

#import "PTSToolConnectOthersViewController.h"
#import "PTSRandomContentProvider.h"
#import "PTSContactsViewController.h"
#import "PTSTool.h"

#pragma mark - Private Interface

@interface PTSToolConnectOthersViewController()

@property(nonatomic, strong) PTSContactsViewController *contactsViewController;
@property(nonatomic, strong) PTSRandomContentProvider *randomContentProvider;

@end

#pragma mark - Implementation

@implementation PTSToolConnectOthersViewController

#pragma mark - UIViewController Methods

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"ContactsEmbeddedSegue"]) {
    self.contactsViewController = segue.destinationViewController;

    [self refreshToolIfPossible];
  }
}

#pragma mark - Action Handlers

/**
 *  handleAddBarButtonItemPressed
 */
- (void)handleAddBarButtonItemPressed:(id)sender {
  [self.contactsViewController initiateAddContactExperience];
}

#pragma mark - PTToolViewDelegate Methods

/**
 *  barButtonItemForRightNavigationItem
 */
- (UIBarButtonItem *)barButtonItemForRightNavigationItem {
  return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                       target:self
                                                       action:@selector(handleAddBarButtonItemPressed:)];
}

/**
 *  refreshToolIfPossible
 *
 *  This method is a little bit silly in that it completely re-creates the header view for the table
 *  each time. However, UITableView's have a tough time properly sizing their tableHeaderViews if the
 *  sizing is determined by auto-layout. The most reliable way is to just re-create a new header view
 *  each time and then have the contacts view controller worry about properly resizing the width and height
 *
 */
- (void)refreshToolIfPossible {
  NSDictionary *item = [self.randomContentProvider nextContentItem];
  NSString *title = item[@"title"];
  NSString *tip = item[@"tip"];

  UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
  containerView.backgroundColor = [UIColor whiteColor];
  containerView.translatesAutoresizingMaskIntoConstraints = NO;

  // Label factory
  UILabel *(^addLabelWithText)(NSString *, UIView *) = ^UILabel *(NSString *text, UIView *anchorView) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody] size:0.0];
    label.numberOfLines = 0;
    label.text = text;
    label.translatesAutoresizingMaskIntoConstraints = NO;

    [containerView addSubview:label];
    [label.leadingAnchor constraintEqualToAnchor:containerView.layoutMarginsGuide.leadingAnchor].active = YES;
    [label.trailingAnchor constraintEqualToAnchor:containerView.layoutMarginsGuide.trailingAnchor].active = YES;
    
    if (anchorView) {
      [label.topAnchor constraintEqualToAnchor:anchorView.bottomAnchor constant:20.0].active = YES;
    } else {
      [label.topAnchor constraintEqualToAnchor:containerView.layoutMarginsGuide.topAnchor].active = YES;
    }
    
    return label;
  };

  UILabel *lastLabel = addLabelWithText(NSLocalizedString(@"It can help to get support from trusted people or to just relax around "
                                                          "others. People who have social support experience fewer physical and "
                                                          "emotional symptoms of stress than those who don’t. Try this:", nil), nil);
  
  if (title.length > 0) {
    lastLabel = addLabelWithText(title, lastLabel);
    lastLabel.textAlignment = NSTextAlignmentCenter;
  }

  if (tip.length > 0) {
    lastLabel = addLabelWithText(tip, lastLabel);
  }

  [lastLabel.bottomAnchor constraintEqualToAnchor:containerView.layoutMarginsGuide.bottomAnchor].active = YES;

  self.contactsViewController.headerView = containerView;
}

#pragma mark - Private Properties

/**
 *  randomContentProvider
 */
- (PTSRandomContentProvider *)randomContentProvider {
  if (!_randomContentProvider) {
    NSArray *items = [NSArray arrayWithContentsOfURL:self.tool.contentURL];
    _randomContentProvider = [[PTSRandomContentProvider alloc] initWithContentItems:items];
  }
  
  return _randomContentProvider;
}

@end
