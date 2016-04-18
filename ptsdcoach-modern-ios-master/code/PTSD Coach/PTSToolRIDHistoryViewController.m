//
//  PTSToolRIDHistoryViewController.m
//  PTSD Coach
//

#import "PTSToolRIDHistoryViewController.h"
#import "PTSDatastore.h"
#import "PTSRIDSession.h"
#import "PTSToolRIDSessionDetailsViewController.h"
#import "PTSRIDSessionTableViewCell.h"

static NSString *const PTSSegueIdentifierShowDetails = @"ShowSessionDetailsSegue";

#pragma mark - Private Interface

@interface PTSToolRIDHistoryViewController ()

@property(nonatomic, strong) NSArray *sessions;
@property(nonatomic, strong) PTSRIDSession *selectedSession;

@end

#pragma mark - Implementation

@implementation PTSToolRIDHistoryViewController

#pragma mark - UIViewController Methods

/**
 *  viewDidLoad
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  [self.tableView registerClass:[PTSRIDSessionTableViewCell class] forCellReuseIdentifier:PTSTableCellIdentifierRIDSession];
}
/**
 *  prepareForSegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:PTSSegueIdentifierShowDetails]) {
    PTSToolRIDSessionDetailsViewController *detailsViewController = (PTSToolRIDSessionDetailsViewController *)segue.destinationViewController;
    detailsViewController.session = self.selectedSession;
  }
}

#pragma mark - Private Properties

/**
 *  sessions
 */
- (NSArray *)sessions {
  if (!_sessions) {
    _sessions = [PTSDatastore sharedDatastore].RIDSessions;
  }
  
  return _sessions;
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
  return self.sessions.count;
}

/**
 *  tableView:cellForRowAtIndexPath
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSRIDSession *session = self.sessions[indexPath.row];
  PTSRIDSessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PTSTableCellIdentifierRIDSession forIndexPath:indexPath];
  [cell prepareWithRIDSession:session];
  
  return cell;
}

#pragma mark - UITableViewDelegate Methods

/**
 *  tableView:didSelectRowAtIndexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PTSRIDSessionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  self.selectedSession = cell.representedSession;

  [self performSegueWithIdentifier:PTSSegueIdentifierShowDetails sender:nil];
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
    PTSRIDSessionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    PTSDatastore *datastore = [PTSDatastore sharedDatastore];
    PTSRIDSession *session = cell.representedSession;
    
    NSMutableArray *mutableRIDSessions = [[NSMutableArray alloc] initWithArray:datastore.RIDSessions];
    [mutableRIDSessions removeObject:session];
    
    datastore.RIDSessions = [mutableRIDSessions copy];
    self.sessions = datastore.RIDSessions;
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

@end
