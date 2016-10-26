/**
 * COMMON FUNCTIONS
 */
/**
 * Replace space in string with %20
 * @param  {string} value
 * @return {string}
 */
function convertToUrl (value) {
  return value.split(' ').join('%20');
}

/**
 * Convert ID get from map path into Region Name
 * @param  {string} name ID of map's path
 * @return {string} Region Name after convert
 */
function convertToRegionName (name) {
  if (name) {
    return name.split('-').join(' ');
  }

}
