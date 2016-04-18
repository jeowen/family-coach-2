//
//  SecondViewController.m
//  PTSD Coach
//

#import "PTSSupportRootViewController.h"
#import "PTSSegmentedTextViewController.h"
#import "PTSBasicTableViewCell.h"

static NSDictionary *sTableRowToNameMappings;
static NSDictionary *sTableRowToSegueMappings;

typedef NS_ENUM(NSInteger, PTSSupportRootViewTableRow) {
  PTSSupportRootViewTableRowCrisisResources = 0,
  PTSSupportRootViewTableRowProfessionalCare,
  PTSSupportRootViewTableRowGrowSupport
};

#pragma mark - Implementation

@implementation PTSSupportRootViewController

#pragma mark - Class Methods

/**
 *  initalize
 */
+ (void)initialize {
  sTableRowToNameMappings = @{ @(PTSSupportRootViewTableRowCrisisResources) : NSLocalizedString(@"Crisis Resources", nil),
                               @(PTSSupportRootViewTableRowProfessionalCare) : NSLocalizedString(@"Find Professional Care", nil),
                               @(PTSSupportRootViewTableRowGrowSupport): NSLocalizedString(@"Grow Your Support", nil) };

  sTableRowToSegueMappings = @{ @(PTSSupportRootViewTableRowCrisisResources) : @"ShowCrisisResourcesSegue",
                                @(PTSSupportRootViewTableRowProfessionalCare) : @"ShowProfessionalCareSegue",
                                @(PTSSupportRootViewTableRowGrowSupport): @"ShowGrowSupportSegue" };
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
  cell.primaryText = sTableRowToNameMappings[@(indexPath.row)];

  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *segueIdentifier = sTableRowToSegueMappings[@(indexPath.row)];
  [self performSegueWithIdentifier:segueIdentifier sender:self];
}

/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"ShowProfessionalCareSegue"]) {
    PTSSegmentedTextViewController *segmentedTextViewController = (PTSSegmentedTextViewController *)segue.destinationViewController;
    segmentedTextViewController.filename = @"Support - Find Professional Care.rtf";
  }
}

@end
