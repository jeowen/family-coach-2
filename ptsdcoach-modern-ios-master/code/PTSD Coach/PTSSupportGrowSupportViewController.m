//
//  PTSSupportGrowSupportViewController.m
//  PTSD Coach
//

#import "PTSSupportGrowSupportViewController.h"
#import "PTSBasicTableViewCell.h"
#import "PTSSegmentedTextViewController.h"

static NSString *const PTSSegueIdentifierShowRichContent = @"ShowRichContentViewSegue";

static NSDictionary *sTableRowToTitleMappings;
static NSDictionary *sTableRowToTitleMappings;

typedef NS_ENUM(NSInteger, PTSSupportGrowSupportViewTableRow) {
  PTSSupportGrowSupportViewTableRowSomeoneTrust = 0,
  PTSSupportGrowSupportViewTableRowFeelingAlone,
  PTSSupportGrowSupportViewTableRowGrowingSupport
};

#pragma mark - Private Interface

@interface PTSSupportGrowSupportViewController()

@property(nonatomic, strong) NSString *richContentScreenTitle;
@property(nonatomic, strong) NSString *richContentFilename;

@end

#pragma mark - Implementation

@implementation PTSSupportGrowSupportViewController

#pragma mark - Class Methods

/**
 *  initialize
 */
+ (void)initialize {
  sTableRowToTitleMappings = @{ @(PTSSupportGrowSupportViewTableRowSomeoneTrust) : NSLocalizedString(@"Someone You Trust", nil),
                                @(PTSSupportGrowSupportViewTableRowFeelingAlone) : NSLocalizedString(@"Feeling Alone", nil),
                                @(PTSSupportGrowSupportViewTableRowGrowingSupport) : NSLocalizedString(@"Growing Your Support", nil) };
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
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierShowRichContent]) {
    PTSSegmentedTextViewController *segmentedTextViewController = (PTSSegmentedTextViewController *)segue.destinationViewController;
    
    segmentedTextViewController.filename = self.richContentFilename;
    segmentedTextViewController.title = self.richContentScreenTitle;
  }
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

  switch (indexPath.row) {
    case PTSSupportGrowSupportViewTableRowSomeoneTrust: {
      self.richContentFilename = @"Support - Someone you trust.rtf";
      self.richContentScreenTitle = NSLocalizedString(@"Someone You Trust", nil);
      break;
    }
      
    case PTSSupportGrowSupportViewTableRowFeelingAlone: {
      self.richContentFilename = @"Support - Feeling Alone.rtf";
      self.richContentScreenTitle = NSLocalizedString(@"Feeling Alone", nil);
      break;
    }
      
    case PTSSupportGrowSupportViewTableRowGrowingSupport: {
      self.richContentFilename = @"Support - Growing your support.rtf";
      self.richContentScreenTitle = NSLocalizedString(@"Growing Your Support", nil);
      break;
    }
  }
  
  [self performSegueWithIdentifier:PTSSegueIdentifierShowRichContent sender:nil];
}

@end
