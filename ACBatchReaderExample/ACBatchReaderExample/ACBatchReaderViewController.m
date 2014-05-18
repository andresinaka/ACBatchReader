//
//  ACBatchReaderViewController.m
//  ACBatchReaderExample
//
//  Created by Andres on 5/18/14.
//  Copyright (c) 2014 Andres Canal. All rights reserved.
//

#import "ACBatchReaderViewController.h"
#import "ACDummyContainer.h"

@interface ACBatchReaderViewController ()
@property (strong, nonatomic) IBOutlet UILabel *labelWithAmountOfRead;
@property (strong, nonatomic) ACBatchReader *batchReader;
@property NSMutableArray *elementsRead;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *dataRead;
@end

@implementation ACBatchReaderViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.batchReader = [[ACBatchReader alloc] init];
    self.batchReader.debug = YES;
    self.batchReader.delegate = self;
    self.batchReader.batchSize = 1;
    [self.batchReader setFileName:@"dummy-data"];
}

- (IBAction)startBatchRead:(id)sender {
    self.status.text = @"Started";
    self.elementsRead = [[NSMutableArray alloc] init];
    [self.batchReader startReadingWithParser:^id(NSDictionary *element) {
        ACDummyContainer *dummy = [[ACDummyContainer alloc] init];
        dummy.city = element[@"city"];
        dummy.country = element[@"country"];
        
        return dummy;
    }];
}

#pragma mark ACBatchReader delegate

- (void) batchRead:(NSArray *)batch{
    [self.elementsRead addObjectsFromArray:batch];
    self.labelWithAmountOfRead.text = [NSString stringWithFormat:@"Number of items read: %d",
                                                                    self.elementsRead.count];
    ACDummyContainer *dummyContainer = [batch firstObject];
    self.dataRead.text = [NSString stringWithFormat:@"%@ %@",dummyContainer.city,dummyContainer.country];
}

- (void) batchFinished{
    self.status.text = @"Finished";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
