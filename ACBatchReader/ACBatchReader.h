//
//  ALFileReader.h
//  AirportLocator
//
//  Created by Andres on 5/18/14.
//  Copyright (c) 2014 Andres Canal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ACBatchReaderDelegate <NSObject>

- (void) batchRead:(NSArray *) batch;
- (void) batchFinished;
@end

@interface ACBatchReader : NSObject
@property BOOL debug;
@property (nonatomic, strong) id <ACBatchReaderDelegate> delegate;
@property NSInteger batchSize;
- (void) setFileName:(NSString *)fileName;
- (void) startReadingWithParser:(id (^)(NSDictionary *element))parser;
@end
