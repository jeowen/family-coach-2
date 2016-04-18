//
//  PTSSymptomsMenuViewController.m
//  PTSD Coach
//

#import "PTSSymptomsMenuViewController.h"
#import "PTSManageSymptomsRootViewController.h"
#import "PTSSymptom.h"

#pragma mark - Private Interface

@interface PTSSymptomsMenuViewController ()

@end

#pragma mark - Implementation

@implementation PTSSymptomsMenuViewController

#pragma mark - IBActions

/**
 *  handleRemindedOfTraumaButtonPressed
 */
- (IBAction)handleRemindedOfTraumaButtonPressed:(id)sender {
  [self prepareManagementSessionWithSymptomIdentifier:PTSSymptomIdentifierRemindedTrauma];
}

/**
 *  handleAvoidingTriggersButtonPressed
 */
- (IBAction)handleAvoidingTriggersButtonPressed:(id)sender {
  [self prepareManagementSessionWithSymptomIdentifier:PTSSymptomIdentifierAvoidingTriggers];
}

/**
 *  handleDisconnectedFromPeopleButtonPressed
 */
- (IBAction)handleDisconnectedFromPeopleButtonPressed:(id)sender {
  [self prepareManagementSessionWithSymptomIdentifier:PTSSymptomIdentifierDisconnectedPeople];
}

/**
 *  handleDisconnectedFromRealityButtonPressed
 */
- (IBAction)handleDisconnectedFromRealityButtonPressed:(id)sender {
  [self prepareManagementSessionWithSymptomIdentifier:PTSSymptomIdentifierDisconnectedReality];
}

/**
 *  handleSadHopelessButtonPressed
 */
- (IBAction)handleSadHopelessButtonPressed:(id)sender {
  [self prepareManagementSessionWithSymptomIdentifier:PTSSymptomIdentifierSadHopeless];
}

/**
 *  handleWorriedAnxiousButtonPressed
 */
- (IBAction)handleWorriedAnxiousButtonPressed:(id)sender {
  [self prepareManagementSessionWithSymptomIdentifier:PTSSymptomIdentifierWorriedAnxious];
}

/**
 *  handleAngryButtonPressed
 */
- (IBAction)handleAngryButtonPressed:(id)sender {
  [self prepareManagementSessionWithSymptomIdentifier:PTSSymptomIdentifierAngry];
}

/**
 *  handleUnableToSleepButtonPressed
 */
- (IBAction)handleUnableToSleepButtonPressed:(id)sender {
  [self prepareManagementSessionWithSymptomIdentifier:PTSSymptomIdentifierUnableSleep];
}

#pragma mark - Private Method

/**
 *  prepareManagementSessionWithSymptomIdentifier
 */
- (void)prepareManagementSessionWithSymptomIdentifier:(PTSSymptomIdentifier)symptomIdentifier {
  NSAssert([self.parentViewController isKindOfClass:[PTSManageSymptomsRootViewController class]], @"Invalid parent view controller class.");
  
  PTSSymptom *symptom = [[PTSSymptom alloc] initWithSymptomIdentifier:symptomIdentifier];
  PTSManageSymptomsRootViewController *rootViewController = (PTSManageSymptomsRootViewController *)self.parentViewController;
  [rootViewController beginManagementSessionWithSymptom:symptom];
}

@end
