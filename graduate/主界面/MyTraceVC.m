//
//  MyTraceVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MyTraceVC.h"

@interface MyTraceVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation MyTraceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [button.titleLabel setText:@"返回"];
    [button setTintColor:[UIColor blueColor]];
    [button.titleLabel setTintColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(backToMain:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [myAddButton setTintColor:[UIColor blueColor]];
    NSArray *myButtonArray = [[NSArray alloc] initWithObjects: myAddButton, nil];
    self.navigationItem.leftBarButtonItems = myButtonArray;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadMusic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 5;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"picture";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}
- (IBAction)backToMain:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(self.view.frame.size.width, 472);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showMyQuestion" sender:nil];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionReusableView * reusableview = nil ;
    if ( kind == UICollectionElementKindSectionHeader ) {
            reusableview = [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @ "myHeader" forIndexPath : indexPath ] ;
        
      
    } else if ( kind == UICollectionElementKindSectionFooter ) {
            reusableview= [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionFooter withReuseIdentifier : @ "myFooter" forIndexPath : indexPath ] ;
        
    }

//    if ( kind == UICollectionElementKindSectionFooter ) {
//           UICollectionReusableView * footerview = [ collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionFooter withReuseIdentifier : @ "myFooter" forIndexPath : indexPath ] ;
//
//            reusableview = footerview;
//        }
    
    return reusableview;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
