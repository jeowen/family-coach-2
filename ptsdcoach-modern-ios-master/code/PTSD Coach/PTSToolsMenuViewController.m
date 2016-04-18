//
//  PTSToolsMenuViewController.m
//  PTSD Coach
//

#import "PTSToolsMenuViewController.h"
#import "PTSBasicTableViewCell.h"
#import "PTSTool.h"
#import "PTSToolManager.h"
#import "PTSToolTableViewCell.h"
#import "PTSManageSymptomsRootViewController.h"

#pragma mark - Private Interface

@interface PTSToolsMenuViewController()

@property(nonatomic, strong) NSArray *customTools;
@property(nonatomic, strong) NSArray *favoriteTools;
@property(nonatomic, strong) NSArray *rejectedTools;
@property(nonatomic, strong) NSArray *standardTools;

@property(nonatomic, assign) NSInteger customToolsTableSection;
@property(nonatomic, assign) NSInteger favoriteToolsTableSection;
@property(nonatomic, assign) NSInteger standardToolsTableSection;
@property(nonatomic, assign) NSInteger rejectedToolsTableSection;

@end

#pragma mark - Implementation

@implementation PTSToolsMenuViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  PTSToolManager *toolManager = [PTSToolManager sharedToolManager];
  
  self.customTools = toolManager.userTools;
  self.rejectedTools = toolManager.rejectedTools;
  self.standardTools = toolManager.standardTools;
  self.favoriteTools = toolManager.favoriteTools;

  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  [self.tableView registerClass:[PTSToolTableViewCell class] forCellReuseIdentifier:PTSTableCellIdentifierTool];
}

#pragma mark - UITableViewDataSource Methods

/**
 *  numberOfSectionsInTableView
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // The three sections are:
  // - Favorite Tools
  // - Custom Tools
  // - Other Tools
  // - Rejected Tools
  
  NSInteger sectionCount = 0;
  
  if (self.favoriteTools.count > 0) {
    sectionCount += 1;
    self.favoriteToolsTableSection = 0;
  } else {
    self.favoriteToolsTableSection = -1;
  }
  
  sectionCount += 1;
  self.customToolsTableSection = self.favoriteToolsTableSection + 1;
  
  sectionCount += 1;
  self.standardToolsTableSection = self.customToolsTableSection + 1;
  
  if (self.rejectedTools.count > 0) {
    sectionCount += 1;
    self.rejectedToolsTableSection = self.standardToolsTableSection + 1;
  } else {
    self.rejectedToolsTableSection = -1;
  }
  
  return sectionCount;
}

/**
 *  tableView:numberOfRowsInSection
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == self.customToolsTableSection) {
    return (self.customTools.count + 1);
  }
  
  if (section == self.favoriteToolsTableSection) {
    return self.favoriteTools.count;
  }
  
  if (section == self.standardToolsTableSection) {
    return self.standardTools.count;
  }
  
  if (section == self.rejectedToolsTableSection) {
    return self.rejectedTools.count;
  }
  
  return 0;
}

/**
 *  tableView:titleForHeaderInSection
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == self.customToolsTableSection) {
    return NSLocalizedString(@"Custom Tools", nil);
  }
  
  if (section == self.favoriteToolsTableSection) {
    return NSLocalizedString(@"Favorites", nil);
  }
  
  if (section == self.rejectedToolsTableSection) {
    return NSLocalizedString(@"Rejected", nil);
  }
  
  return nil;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Special case the "New Custom Tool" cell as it's a static cell.
  if (indexPath.section == self.customToolsTableSection && indexPath.row == 0) {
    PTSBasicTableViewCell *cell = [[PTSBasicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.primaryText = NSLocalizedString(@"New Custom Tool", nil);
    
    return cell;
  }
  
  PTSTool *tool;
  PTSToolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierTool forIndexPath:indexPath];
  
  if (indexPath.section == self.customToolsTableSection && indexPath.row != 0) {
    tool = self.customTools[indexPath.row - 1];
  }
  
  if (indexPath.section == self.favoriteToolsTableSection) {
    tool = self.favoriteTools[indexPath.row];
  }
  
  if (indexPath.section == self.standardToolsTableSection) {
    tool = self.standardTools[indexPath.row];
  }
  
  if (indexPath.section == self.rejectedToolsTableSection) {
    tool = self.rejectedTools[indexPath.row];
  }
  
  if (tool) {
    [cell prepareWithTool:tool];
  }

  return cell;
}

/**
 *  didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == self.customToolsTableSection && indexPath.row == 0) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
  }
  
  PTSToolTableViewCell *toolCell = (PTSToolTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  PTSTool *selectedTool = toolCell.representedTool;
  
/*
  if (indexPath.section == self.customToolsTableSection) {
    if (indexPath.row == 0) {
      NSLog(@"Show Custom Tool Screen");
    } else {
      selectedTool = self.customTools[indexPath.row - 1];
    }
  }
  
  if (indexPath.section == self.favoriteToolsTableSection) {
    selectedTool = self.favoriteTools[indexPath.row];
  }
  
  if (indexPath.section == self.standardToolsTableSection) {
    selectedTool = self.standardTools[indexPath.row];
  }
  
  if (indexPath.section == self.rejectedToolsTableSection) {
    selectedTool = self.rejectedTools[indexPath.row];
  }
  */
  
  if (selectedTool) {
    PTSManageSymptomsRootViewController *rootViewController = (PTSManageSymptomsRootViewController *)self.parentViewController;
    [rootViewController beginManagementSessionWithTool:selectedTool];
  }
}

@end
