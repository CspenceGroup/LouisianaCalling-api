  /**
   * Replace space in string with %20
   * @param  {string} value
   * @return {string}
   */
  function convertToUrl (value) {
    return value.split(' ').join('%20');
  }
