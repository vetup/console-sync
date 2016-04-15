//
// ModuleVetoDataListTabController.j
//
// Created by Philippe Fuentes.
//
@import <Foundation/Foundation.j>
@import <Foundation/CPObject.j>

//Permet de pouvoir utiliser les objets suivant lies aux tabs
@import "User/ModuleCleanUserController.j"
@import "User/ModuleUniqueUserController.j"


/*
Assainissement des users:
- liste de tous les users en doublons
- liste de toutes les emails "suspectes"
- Text area du résultat de l'analyse (nombre d'email pourrie...)
- fonction de suppression des users avec email pourri

Création des users dans la nouvelle table vetup_crv_user:
- création de la table avec unique id sur l'email
- création de la table d'association des nouveau vetup_crv_user avec les vetup_user



*/

@implementation ModuleUserTabController : CPObject
{
    @outlet CPView _tabView;
  //  @outlet CPView _containerView;


    //@outlet ModuleColorDataListController     _colorDataListController;
}

- (id)init
{
    CPLog.info(@">>>> Entering ModuleUserTabController.j::init");

    CPLog.info(@"<<<< Leaving ModuleUserTabController.j::init");

    return self;
}


- (void)awakeFromCib
{
 //   CPLog.debug(@">>>> Entering TestTemplateTabController::awakeFromCib");

    [_tabView setBackgroundColor:[CPColor whiteColor]];


//    CPLog.debug(@"<<<< Leaving TestTemplateTabController::awakeFromCib");
}


- (void)refresh
{

}


//----o PUBLIC
#pragma mark -
#pragma mark Action



#pragma mark -
#pragma mark IB Action



@end





