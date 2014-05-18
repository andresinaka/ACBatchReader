//
//  ALFileReader.m
//  AirportLocator
//
//  Created by Andres on 5/18/14.
//  Copyright (c) 2014 Andres Canal. All rights reserved.
//

#import "ACBatchReader.h"

@interface ACBatchReader()
@property (nonatomic,strong) NSString *filePath;
@end

@implementation ACBatchReader

- (id) init{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.debug = NO;
    return self;
}

- (void) setFileName:(NSString *)fileName{
    self.filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
}

- (void) startReadingWithParser:(id (^)(NSDictionary *element))parser{
    if (![self.delegate respondsToSelector:@selector(batchRead:)]) {
        NSLog(@"No delegate is available to return the batch");
        return;
    }

    NSArray *contentArray = [NSArray arrayWithContentsOfFile:self.filePath];
    NSMutableArray *batch = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        id temporalElement = nil;
        for (NSDictionary *element in contentArray) {
            temporalElement = parser(element);
            
            if (temporalElement) {
                [batch addObject:temporalElement];
            }
            
            if (batch.count == self.batchSize) {
                [self dispatchBatch:batch];
                [batch removeAllObjects];
            }
        }
        if (batch.count > 0) {
            [self dispatchBatch:batch];
        }
        
        if ([self.delegate respondsToSelector:@selector(batchFinished)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate batchFinished];
            });
        }
    });
}

- (void) dispatchBatch:(NSMutableArray *)batch{
    NSMutableArray *batchToDispatch = [batch copy];

    if (self.debug) {
        [NSThread sleepForTimeInterval:0.0001];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate batchRead:batchToDispatch];
    });
}

@end
