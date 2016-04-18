//
//  PTSContactsViewController.m
//  PTSD Coach
//

@import Contacts;
@import ContactsUI;

#import "PTSContactsViewController.h"
#import "PTSContactTableViewCell.h"
#import "PTSDatastore.h"

static NSString *const PTSContactsTableCellIdentifierContact = @"TableCellIdentifierContact";
static NSString *const PTSContactsTableCellIdentifierEmptyList = @"TableCellIdentifierNoContacts";

#pragma mark - Private Interface

@interface PTSContactsViewController()<CNContactPickerDelegate, CNContactViewControllerDelegate>

@property(nonatomic, strong) NSArray *contactRecords;

@end

#pragma mark - Implementation

@implementation PTSContactsViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];

  self.contactRecords = [PTSDatastore sharedDatastore].supportContacts;

  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  [self.tableView registerClass:[PTSContactTableViewCell class] forCellReuseIdentifier:PTSContactsTableCellIdentifierContact];
}

/**
 *  viewDidLayoutSubviews
 */
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  [self validateHeaderViewSize];
}

#pragma mark - Public Properties

/**
 *  headerView
 */
- (void)setHeaderView:(UIView *)headerView {
  _headerView = headerView;
  
  [self validateHeaderViewSize];
}

#pragma mark - Public Methods

/**
 *  initiateAddContactExperience
 */
- (void)initiateAddContactExperience {
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
  
  UIAlertAction *existingContactAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Pick from contact list", nil)
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                  [self showContactPicker];
                                                                }];
  
  UIAlertAction *newContactAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Create new contact", nil)
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                             [self showNewContactView];
                                                           }];
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Add Contact", nil)
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
  
  [alertController addAction:cancelAction];
  [alertController addAction:existingContactAction];
  [alertController addAction:newContactAction];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - IBActions

/**
 *  handleAddContactButton
 */
- (IBAction)handleAddContactButton:(id)sender {
  [self initiateAddContactExperience];
}

#pragma mark - CNContactPickerDelegate Methods

/**
 *  contactPicker:didSelectContact
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
  if (self.contactRecords) {
    self.contactRecords = [self.contactRecords arrayByAddingObject:contact];
  } else {
    self.contactRecords = @[contact];
  }
  
  [PTSDatastore sharedDatastore].supportContacts = self.contactRecords;
  
  [self.tableView reloadData];
}

#pragma mark - CNContactViewControllerDelegate Methods

/**
 *  contactViewController:didCompleteWithContact
 */
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact {
  // TODO: Save contact to contacts store...
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  numberOfSectionsInTableView
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Always return at least 1 row because we use a row to show an "Empty" message to the user.
  return MAX(self.contactRecords.count, 1);
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // If there are no records, then return the "Empty" message cell.
  if (self.contactRecords.count == 0) {
    return [tableView dequeueReusableCellWithIdentifier:PTSContactsTableCellIdentifierEmptyList forIndexPath:indexPath];
  }
  
  PTSContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PTSContactsTableCellIdentifierContact forIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryNone;
  [cell prepareWithContact:self.contactRecords[indexPath.row]];

  return cell;
}

/**
 *  tableView:titleForHeaderInSection
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return NSLocalizedString(@"Support Contacts", nil);
  }
  
  return nil;
}

/**
 *  canEditRowAtIndexPath
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

/**
 *  tableView:commitEditingStyle
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSMutableArray *mutableContactRecords = [[NSMutableArray alloc] initWithArray:self.contactRecords];
    [mutableContactRecords removeObjectAtIndex:indexPath.row];
    
    self.contactRecords = [mutableContactRecords copy];
    [PTSDatastore sharedDatastore].supportContacts = self.contactRecords;
    
    // If there are no more records, then perform a full reload otherwise the table view will
    // complain that we've deleted the last row but we're saying there is still one row in
    // the section (the row that will show the empty message). 
    if (self.contactRecords.count == 0) {
      [tableView reloadData];
    } else {
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
  }
}

#pragma mark - Private Methods

/**
 *  showContactPicker
 */
- (void)showContactPicker {
  NSMutableSet *existingContactIdentifiers = [[NSMutableSet alloc] initWithCapacity:self.contactRecords.count];
  for (CNContact *contact in self.contactRecords) {
    [existingContactIdentifiers addObject:contact.identifier];
  }
  
  CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
  contactPicker.delegate = self;
  contactPicker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"NOT (identifier IN %@)", existingContactIdentifiers];
  
  [self presentViewController:contactPicker animated:YES completion:nil];
}

/**
 *  showNewContactView
 */
- (void)showNewContactView {
  // TODO: Needs contact store...
  CNMutableContact *contact = [[CNMutableContact alloc] init];
  CNContactViewController *viewController = [CNContactViewController viewControllerForNewContact:contact];
  viewController.delegate = self;
  
  [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  validateHeaderViewSize
 *
 *  UITableView needs a bit of help in determining how high its tableHeaderView is if the
 *  tableHeaderView has a dynamic height and is being layed out by auto-layout. This method
 *  takes a brute-force approach and just wraps the user's headerView into a wrapper view and
 *  explicitly sets the width and then computes the appropriate height. Seems to work OK...
 *
 *  /shrug
 *
 */
- (void)validateHeaderViewSize {
  if (!self.headerView && !self.tableView.tableHeaderView) {
    return;
  }
  
  UIView *headerViewWrapper = [[UIView alloc] initWithFrame:CGRectZero];
  headerViewWrapper.translatesAutoresizingMaskIntoConstraints = NO;
  
  [headerViewWrapper addSubview:self.headerView];
  
  NSDictionary *views = @{ @"header" : self.headerView };
  [headerViewWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:nil views:views]];
  [headerViewWrapper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header]|" options:0 metrics:nil views:views]];
  [headerViewWrapper.widthAnchor constraintEqualToConstant:CGRectGetWidth(self.tableView.frame)].active = YES;
  
  // With the constraints in place, for a layout pass to determine the appropriate size.
  [headerViewWrapper setNeedsLayout];
  [headerViewWrapper layoutIfNeeded];
  
  CGRect frame = headerViewWrapper.frame;
  frame.size.height = [headerViewWrapper systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  headerViewWrapper.frame = frame;
  
  self.tableView.tableHeaderView = headerViewWrapper;
}

@end
