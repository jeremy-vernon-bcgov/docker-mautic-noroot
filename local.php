<?php
    $parameters['db_driver'] = 'pdo_mysql';
    $parameters['instalL_source'] = 'Docker';
    $parameters['db_port'] = '3306';
    $parameters['db_host'] = $_ENV['MAUTIC_DB_HOST'];
    $parameters['db_name'] = $_ENV['MAUTIC_DB_NAME'];
    $parameters['db_table_prefix'] = '';
    $parameters['db_user'] = $_ENV['MAUTIC_DB_USER'];
    $parameters['db_password'] = $_ENV['MAUITC_DB_PASSWORD'];
    $parameters['default_timezone'] = $_ENV['PHP_INI_DATE_TIMEZEONE'];
