#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = '''
---
module: pcs_resource
short_description: Manages I(pacemaker) cluster resources with pcs tool.
options:
  command:
    required: true
    description: Supported commands.
    choices: [ "create", "master"]
  resource_id:
    required: true
    description: Id of the resource.
  type:
    required: true
    description: type of resource. Used in «create» command.
  ms_name:
    required: true
    description: name of the resource. Used in «master» command.
  options:
    required: false
    description: hash of resource options.
  operations:
    required: false
    description: list of hashes of operations. Used in «create» command.
'''

def main():
    module = AnsibleModule(
        argument_spec   = dict(
            command    = dict(choices=['create', 'master']),
            name       = dict(required=True, aliases=['resource_id']),
            type       = dict(required=False),
            options    = dict(required=False),
            operations = dict(required=False),
            meta       = dict(required=False),
            group      = dict(required=False),
            clone      = dict(required=False, choices=['yes', 'no']),
            master     = dict(required=False, choices=['yes', 'no']),
        ),
        supports_check_mode=True,
    )

    # TODO check pcs command is available.
    # TODO check pacemaker/corosync is running.

    # Check if resource already exists.
    cmd = "pcs resource show %(name)s"  % module.params
    rc, out, err = module.run_command(cmd)
    exists = (rc is 0)

    if exists:
        module.exit_json(changed=False, msg="Resource already exists.")
    elif module.check_mode:
        module.exit_json(changed=True)

    # Validate and process command specific params.
    if module.params['command'] == 'create':
        if not module.params.has_key('type') or not bool(module.params['type']):
            module.fail_json(msg="missing required arguments: type.")
        # Command template.
        cmd = 'pcs resource %(command)s %(name)s %(type)s %(options)s'
        # Process operations.
        if module.params.has_key('operations') and bool(module.params['operations']):
            cmd += ' %(operations)s'
            operations = []
            for op in module.params['operations']:
                op['options'] = ' '.join(['%s="%s"' % (key, value) for (key, value) in op['options'].items()])
                operations.append('op %(action)s %(options)s' % op)
            module.params['operations'] = ' '.join(operations)
        # Process meta parameters.
        if module.params.has_key('meta') and bool(module.params['meta']):
            cmd += ' meta %(meta)s'
            meta = module.params['meta']
            meta = ' '.join(['%s="%s"' % (key, value) for (key, value) in meta.items()])
            module.params['meta'] = meta

    elif module.params['command'] == 'master':
        if not module.params.has_key('options') and bool(module.params['options']):
            module.fail_json(msg="missing required arguments: options.")
        # Command template.
        cmd = 'pcs resource %(command)s %(ms_name)s %(name)s %(options)s'

    # Process options.
    if module.params.has_key('options') and bool(module.params['options']):
        options = module.params['options']
        options = ' '.join(['%s="%s"' % (key, value) for (key, value) in options.items()])
        module.params['options'] = options

    if module.params.has_key('group') and bool(module.params['group']):
        cmd += ' --group %(group)s'

    if module.params.has_key('clone') and module.params['clone'] == 'yes':
        cmd += ' --clone'

    if module.params.has_key('master') and module.params['master'] == 'yes':
        cmd += ' --master'


    # Run command.
    cmd = cmd % module.params
    rc, out, err = module.run_command(cmd)
    if rc is 1:
        module.fail_json(msg="Execution failed.\nCommand: `%s`\nError: %s" % (cmd, err))

    module.exit_json(changed=(rc is 0))

# import module snippets
from ansible.module_utils.basic import *
main()

