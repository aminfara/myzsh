local present, _ = pcall(require, 'impatient')
if not present then
    require('vima.utils').notify_missing('impatient')
end

require('vima.core')
require('vima.plugins')
