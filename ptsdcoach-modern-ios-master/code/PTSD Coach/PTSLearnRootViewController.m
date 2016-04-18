//
//  PTSLearnTableViewController.m
//  PTSD Coach
//

#import "PTSLearnRootViewController.h"
#import "PTSContentMenuViewController.h"
#import "PTSBasicTableViewCell.h"

static NSDictionary *sTableRowToTitleMappings;

typedef NS_ENUM(NSInteger, PTSLearnRootViewTableRow) {
  PTSLearnRootViewTableRowAbout = 0,
  PTSLearnRootViewTableRowProfessionalHelp,
  PTSLearnRootViewTableRowFamily
};

#pragma mark - Private Interface

@interface PTSLearnRootViewController ()

@property(nonatomic, assign) NSUInteger selectedRow;
@property(nonatomic, strong) NSString *selectedRowTitle;
@property(nonatomic, strong) NSDictionary *contentToBeLoaded;

@end

@implementation PTSLearnRootViewController

#pragma mark - Class Methods

/**
 *  initialize
 */
+ (void)initialize {
  sTableRowToTitleMappings = @{ @(PTSLearnRootViewTableRowAbout) : NSLocalizedString(@"Learn About PTSD", nil),
                                @(PTSLearnRootViewTableRowProfessionalHelp) : NSLocalizedString(@"Getting professional help", nil),
                                @(PTSLearnRootViewTableRowFamily) : NSLocalizedString(@"PTSD and the family", nil) };
}

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

/**
 *  prepareForSegue:sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  PTSContentMenuViewController *contentMenuViewController = (PTSContentMenuViewController *)segue.destinationViewController;
  contentMenuViewController.content = self.contentToBeLoaded;
  contentMenuViewController.title = self.selectedRowTitle;
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
  return 3;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSBasicTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierBasic];
  cell.primaryText = sTableRowToTitleMappings[@(indexPath.row)];

  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedRow = indexPath.row;

  switch (indexPath.row) {
    case PTSLearnRootViewTableRowAbout: {
      NSURL *contentURL = [[NSBundle mainBundle] URLForResource:@"Learn Menu - About PTSD" withExtension:@"plist"];
      self.contentToBeLoaded = [NSDictionary dictionaryWithContentsOfURL:contentURL];
      self.selectedRowTitle = NSLocalizedString(@"About PTSD", nil);
      
      break;
    }
      
    case PTSLearnRootViewTableRowProfessionalHelp: {
      NSURL *contentURL = [[NSBundle mainBundle] URLForResource:@"Learn Menu - Professional Help" withExtension:@"plist"];
      self.contentToBeLoaded = [NSDictionary dictionaryWithContentsOfURL:contentURL];
      self.selectedRowTitle = NSLocalizedString(@"Getting Help", nil);

      break;
    }
      
    case PTSLearnRootViewTableRowFamily: {
      NSURL *contentURL = [[NSBundle mainBundle] URLForResource:@"Learn Menu - PTSD Family" withExtension:@"plist"];
      self.contentToBeLoaded = [NSDictionary dictionaryWithContentsOfURL:contentURL];
      self.selectedRowTitle = NSLocalizedString(@"PTSD & Family", nil);
      
      break;
    }
  }
  
  [self performSegueWithIdentifier:@"ShowContentMenuSegue" sender:self];
}

@end
