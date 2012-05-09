use strict;
use warnings;

use Test::More;
use Test::Exception;
use Test::Differences;
use File::Temp ();
use DBICx::Generator::ExtJS::Model;
use lib 't/lib';
use My::Schema;

my $schema = My::Schema->connect;

my $generator = DBICx::Generator::ExtJS::Model->new(
    schema    => $schema,
    appname   => 'MyApp',
    json_args => {
        space_after => 1,
        indent      => 1,
    },
    extjs_args => { extend => 'MyApp.data.Model' },
);

my $extjs_model_for_another;
lives_ok { $extjs_model_for_another = $generator->extjs_model('Another') }
"generation of 'Another' successful";
eq_or_diff(
    $extjs_model_for_another,
    [   'Another',
        {   'extend'       => 'MyApp.data.Model',
            'associations' => [
                {   'foreignKey'     => 'id',
                    'model'          => 'Basic',
                    'type'           => 'hasMany',
                    'associationKey' => 'get_Basic',
                    'primaryKey'     => 'another_id',
                }
            ],
            'fields' => [
                {   'type' => 'int',
                    'name'      => 'id',
                },
                {   'type' => 'int',
                    'name'      => 'num',
                },
            ],
 	    'validations' => [
		{                     
		  field => 'id',      
		  type => 'presence',  
		},                     
            ],   
            'idProperty' => 'id',
        }
    ],
    "'Another' model ok"
);

my $extjs_store_for_another;
lives_ok { $extjs_store_for_another = $generator->extjs_store('Another') }
"generation of 'Another' successful";
eq_or_diff(
    $extjs_store_for_another,
	[                                    
		'Another',                         
		{                                  
				autoload => 'true',              
				extend => 'Ext.data.Store',      
				model => 'MyApp.model.Another',  
				proxy => {                       
						type => 'ajax',                
						url => '/Another'              
				}    
		}
	],
"'Another' model ok"
);

my $extjs_controller_for_another;
lives_ok { $extjs_controller_for_another = $generator->extjs_controller('Another') }
"generation of 'Another' successful";
eq_or_diff(
    $extjs_controller_for_another,
		[                                                                            
		  'Another',                                                                 
		  {                                                                          
			extend => 'Ext.data.Controller',                                         
			init => 'function() { console.info(\'Another controller started\'); }',  
			models => [                                                              
			  'Another'                                                              
			],                                                                       
			stores => [                                                              
			  'Another'                                                              
			],                                                                       
			views => [                                                               
			  'another.Form'                                                         
			]                                                                        
		  }                                                                          
		],
"'Another' controller ok"
);

my $extjs_models;
lives_ok { $extjs_models = $generator->extjs_models; }
'generation successful';
eq_or_diff(
    $extjs_models,
    {   'Another' => [
            'Another',
            {   'extend'       => 'MyApp.data.Model',
                'associations' => [
                    {   'foreignKey'     => 'id',
                        'model'          => 'Basic',
                        'type'           => 'hasMany',
                        'associationKey' => 'get_Basic',
                        'primaryKey'     => 'another_id',
                    }
                ],
                'fields' => [
                    {   'type' => 'int',
                        'name'      => 'id',
                    },
                    {   'type' => 'int',
                        'name'      => 'num',
                    },
                ],
		'validations' => [
			{                     
				field => 'id',      
				type => 'presence',  
			},                     
		],   
                'idProperty' => 'id',
            },
        ],
        'Basic' => [
            'Basic',
            {   'extend'       => 'MyApp.data.Model',
                'associations' => [
                    {   'foreignKey'     => 'another_id',
                        'model'          => 'Another',
                        'associationKey' => 'another_id',
                        'type'           => 'belongsTo',
                        'primaryKey'     => 'id',
                    }
                ],
                'fields' => [
                    {   'type' => 'int',
                        'name'      => 'id',
                    },
                    {   'type'     => 'string',
                        'defaultValue' => 'hello',
                        'name'          => 'title',
                    },
                    {   'type' => 'string',
                        'name'      => 'description',
                    },
                    {   'type' => 'string',
                        'name'      => 'email',
                    },
                    {   'type'     => 'string',
                        'defaultValue' => undef,
                        'name'          => 'explicitnulldef',
                    },
                    {   'type'     => 'string',
                        'defaultValue' => '',
                        'name'          => 'explicitemptystring',
                    },
                    {   'type' => 'string',
                        'name'      => 'emptytagdef',
                    },
                    {   'type'     => 'int',
                        'defaultValue' => 2,
                        'name'          => 'another_id',
                    },
                    {   'type' => 'date',
                        'name'      => 'timest',
                    },
					{
						'type' => 'boolean',  
						'name' => 'boolfield',
						'defaultValue' => \'true',
					}   
                ],
	      'validations' => [                     
		     {                               
		       field => 'id',                
		       type => 'presence',            
		     },                              
		     {                               
		       field => 'title',             
			   type => 'length',
			   max   => 100,
			 },
		     {                               
		       field => 'title',             
		       type => 'presence',            
		     },                              
			 {                              
				field => 'email',            
				max => 500,                  
				type => 'length',
			 },                
		     {                               
		       field => 'boolfield',         
		       type => 'presence',            
		     }                               
          ],          
          'idProperty' => 'id',
         },
        ],
    },
    "extjs_models output ok"
);

my $extjs_stores;
lives_ok { $extjs_stores = $generator->extjs_stores; }
'generation successful';
eq_or_diff(
    $extjs_stores,
	{
		Another => [                         
		  'Another',                         
		  {                                  
			autoload => 'true',              
			extend => 'Ext.data.Store',      
			model => 'MyApp.model.Another',  
			proxy => {                       
			  type => 'ajax',                
			  url => '/Another'              
			}                                
		  }                                  
		],                                   
		Basic => [                           
		  'Basic',                           
		  {                                  
			autoload => 'true',              
			extend => 'Ext.data.Store',      
			model => 'MyApp.model.Basic',    
			proxy => {                       
			  type => 'ajax',                
			  url => '/Basic'                
			}                                
		  }                                  
		]                                    
	},
    "extjs_stores output ok"
);

my $extjs_controllers;
lives_ok { $extjs_controllers = $generator->extjs_controllers; }
'generation successful';
eq_or_diff(
    $extjs_controllers,
{                                                                              
		  Another => [                                                                 
			'Another',                                                                 
			{                                                                          
			  extend => 'Ext.data.Controller',                                         
			  init => 'function() { console.info(\'Another controller started\'); }',  
			  models => [                                                              
				'Another'                                                              
			  ],                                                                       
			  stores => [                                                              
				'Another'                                                              
			  ],                                                                       
			  views => [                                                               
				'another.Form'                                                         
			  ]                                                                        
			}                                                                          
		  ],                                                                           
		  Basic => [                                                                   
			'Basic',                                                                   
			{                                                                          
			  extend => 'Ext.data.Controller',                                         
			  init => 'function() { console.info(\'Basic controller started\'); }',    
			  models => [                                                              
				'Basic'                                                                
			  ],                                                                       
			  stores => [                                                              
				'Basic'                                                                
			  ],                                                                       
			  views => [                                                               
				'basic.Form'                                                           
			  ]                                                                        
			}                                                                          
		  ]                                                                            
	},
    "extjs_controllers output ok"
);

# this creates a File::Temp object which immediatly goes out of scope and
# results in deleting of the dir
my $non_existing_dirname = File::Temp->newdir->dirname;

#diag("non-existing dir is $non_existing_dirname");
#throws_ok { $generator->extjs_model_to_file( 'Another', $non_existing_dirname ) }
#qr/directory doesn't exist/, "non existing output directory throws ok";

{
    my $dir = File::Temp->newdir;
    my $dirname = $dir->dirname;
    diag("writing 'Another' to $dirname");
    lives_ok { $generator->extjs_model_to_file( 'Another', $dirname ) }
    "model file generation of 'Another' ok";
}

{
    my $dir = File::Temp->newdir;
    my $dirname = $dir->dirname;
    diag("writing all models to $dirname");
    lives_ok { $generator->extjs_models_to_file( $dirname ) }
    "file generation of all models ok";
}

{
    my $dir = File::Temp->newdir;
    my $dirname = $dir->dirname;
    diag("writing 'Another' store to $dirname");
    lives_ok { $generator->extjs_store_to_file( 'Another', $dirname ) }
    "store file generation of 'Another' ok";
}

{
    my $dir = File::Temp->newdir;
    my $dirname = $dir->dirname;
    diag("writing all stores to $dirname");
    lives_ok { $generator->extjs_stores_to_file( $dirname ) }
    "file generation of all stores ok";
}

{
    my $dir = File::Temp->newdir;
    my $dirname = $dir->dirname;
    diag("writing 'Another' controller to $dirname");
    lives_ok { $generator->extjs_controller_to_file( 'Another', $dirname ) }
    "controller file generation of 'Another' ok";
}

{
    my $dir = File::Temp->newdir;
    my $dirname = $dir->dirname;
    diag("writing all controllers to $dirname");
    lives_ok { $generator->extjs_controllers_to_file( $dirname ) }
    "file generation of all controllers ok";
}

{
    my $dir = File::Temp->newdir;
    my $dirname = $dir->dirname;
	$dirname = 'MVC';
    diag("writing all to $dirname");
    lives_ok { $generator->extjs_MVC_to_file( $dirname ) }
    "file generation of all ok";
}

ok(1 == 2);

done_testing;
