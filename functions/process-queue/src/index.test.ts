function test():boolean {
  return true;
}

describe('index', () => {
  it('should pass', () => {
    expect(test()).toBe(true);
  });
});
