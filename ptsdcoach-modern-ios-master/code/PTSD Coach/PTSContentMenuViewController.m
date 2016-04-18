//
//  PTSContentMenuViewController.m
//  PTSD Coach
//

#import "PTSContentMenuViewController.h"
#import "PTSSegmentedTextViewController.h"
#import "PTSBasicTableViewCell.h"

@interface PTSContentMenuViewController ()

@property(nonatomic, strong) NSString *filenameToLoad;
@property(nonatomic, strong) NSString *pageTitle;

@end

@implementation PTSContentMenuViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  [self.tableView registerClass:[PTSBasicTableViewCell class] forCellReuseIdentifier:PTSTableCellIdentifierBasic];
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
  NSArray *menuItems = self.content[@"menuItems"];
  return menuItems.count;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSBasicTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierBasic];
  
  NSArray *menuItems = self.content[@"menuItems"];
  NSDictionary *item = menuItems[indexPath.row];
  cell.primaryText = item[@"menuTitle"];
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *menuItems = self.content[@"menuItems"];
  NSDictionary *item = menuItems[indexPath.row];

  self.filenameToLoad = item[@"filename"];
  self.pageTitle = item[@"pageTitle"];
  
  [self performSegueWithIdentifier:@"ShowSegmentedTextViewSegue" sender:nil];
}

#pragma mark - UIViewController Methods

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"ShowSegmentedTextViewSegue"]) {
    PTSSegmentedTextViewController *segmentedTextViewController = (PTSSegmentedTextViewController *)segue.destinationViewController;
    
    segmentedTextViewController.filename = self.filenameToLoad;
    segmentedTextViewController.title = self.pageTitle;
  }
}

@end
