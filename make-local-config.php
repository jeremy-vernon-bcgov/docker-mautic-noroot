<?php
//Generates the correct Config file from template.

//Check to see if local.php contains the the default content or not.
include_once('/var/www/html/app/config/local.php');

if ($parameters['site_url'] != getenv('SITE_URL')) :
    $parameters = array(
        'db_driver'             => 'pdo_mysql',
        'install_source'        => 'Docker',
        'db_port'               => '3306',
        'db_host'               => getenv('MAUTIC_DB_HOST'),
        'db_name'               => getenv('MAUTIC_DB_NAME'),
        'db_table_prefix'       => null,
        'db_user'               => getenv('MAUTIC_DB_USER'),
        'db_password'           => getenv('MAUTIC_DB_PASSWORD'),
        'default_timezone'      => null,
        'db_backup_tables'      => 0,
        'db_backup_prefix'      => null,
        'mailer_from_name'      => getenv('MAILER_FROM_NAME'),
        'mailer_from_email'     => getenv('MAILER_FROM_EMAIL'),
        'mailer_transport'      => getenv('MAILER_TRANSPORT'),
        'mailer_host'           => getenv('MAILER_USER'),
        'mailer_port'           => getenv('MAILER_PORT'),
        'mailer_user'           => getenv('MAILER_USER'),
        'mailer_password'       => null,
        'mailer_amazon_region'  => 'us-east-1',
        'mailer_amazon_other_region' => null,
        'mailer_api_key'        => null,
        'mailer_encryption'     => null,
        'mailer_auth_mode'      => null,
        'mailer_spool_type'     => 'memory',
        'mailer_spool_path'     => '%kernel.root_dir%/../var/spool',
        'secret_key'            => getenv('HASH_KEY'),
        'site_url'              => getenv('SITE_URL'),
    );
    $path = '/var/www/html/app/config/local.php';
    $rendered = "<?php\n$parameters =".var_export($parameters, true).";\n";
    $status = file_put_contents($path, $rendered);
    if ($status === false) {
        fwrite($stderr, "\nCould not write configuration file to $path, you can create this file with the following contents:\n\n$rendered\n");
    }

endif;
