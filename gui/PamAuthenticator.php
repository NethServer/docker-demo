<?php
namespace Nethgui\Utility;

/*
 * Copyright (C) 2012 Nethesis S.r.l.
 *
 * This script is part of NethServer.
 *
 * NethServer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * NethServer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with NethServer.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * A method class wrapper to perform password authentication through /sbin/e-smith/pam-authenticate-pw
 * script
 *
 * @author Davide Principi <davide.principi@nethesis.it>
 * @since 1.0
 */
class PamAuthenticator implements \Nethgui\Log\LogConsumerInterface, \Nethgui\Utility\PhpConsumerInterface
{
    /**
     *
     * @var PhpWrapper
     */
    private $php;

    /**
     *
     * @var \Nethgui\Log\LogInterface
     */
    private $log;

    /**
     * 
     *
     * @param \Nethgui\Utility\PhpWrapper $php
     * @param \Nethgui\Log\LogInterface $log
     */
    public function __construct(\Nethgui\Utility\PhpWrapper $php = NULL, \Nethgui\Log\LogInterface $log = NULL)
    {
        if (is_null($php)) {
            $php = new \Nethgui\Utility\PhpWrapper(get_class($this));
        }
        $this->php = $php;
        $this->log = $log;
    }

    /**
     * If the given $username/$password credentials are accepted, `groups` and
     * `username` keys will be added to $credentials array.
     *
     * - username: a string, same as $username argument
     * - groups: an array of strings, corresponding to user's group identifiers
     *
     * @param string $username
     * @param string $password
     * @param array &$credentials
     * @return boolean TRUE, if authentication is successful, FALSE otherwise
     */
    public function authenticate($username, $password, &$credentials)
    {
        $php = $this->php;
        $log = $this->getLog();

        $processPipe = $php->popen('/bin/true >/dev/null 2>&1', 'w');
        if ($processPipe === FALSE) {
            $log->error(sprintf('%s: %s', __CLASS__, implode(' ', $php->error_get_last())));
            return FALSE;
        }

        $php->fwrite($processPipe, $username . "\n" . $password);

        $authenticated = $php->pclose($processPipe) === 0;

        if ($authenticated) {

            $exitCode = 0;
            $output = array();

            $command = sprintf('/usr/bin/id -G -n %s 2>&1', escapeshellarg($username));

            $php->exec($command, $output, $exitCode);

            if ($exitCode === 0) {
                $groups = array_filter(array_map('trim', explode(' ', implode(' ', $output))));
            } else {
                $log->warning(sprintf('%s: failed to execute %s command. Code %d. Output: %s', __CLASS__, $command, $exitCode, implode("\n", $output)));
                $groups = array();
            }

            $credentials['groups'] = $groups;
            $credentials['username'] = $username;
        }

        return $authenticated;
    }

    public function getLog()
    {
        if ( ! isset($this->log)) {
            $this->log = new \Nethgui\Log\Nullog();
        }

        return $this->log;
    }

    public function setLog(\Nethgui\Log\LogInterface $log)
    {
        $this->log = $log;
        return $this;
    }

    public function setPhpWrapper(\Nethgui\Utility\PhpWrapper $object)
    {
        $this->php = $object;
        return $this;
    }

}