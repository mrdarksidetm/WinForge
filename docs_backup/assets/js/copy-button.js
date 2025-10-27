document.addEventListener('DOMContentLoaded', function() {
  // Find all code blocks
  const codeBlocks = document.querySelectorAll('pre code');
  
  codeBlocks.forEach((block) => {
    // Skip if already has a button
    if (block.parentNode.querySelector('.copy-btn')) return;
    
    // Create button
    const button = document.createElement('button');
    button.className = 'copy-btn';
    button.innerHTML = '📋';
    button.title = 'Copy to clipboard';
    button.style.cssText = `
      position: absolute; top: 8px; right: 8px; background: rgba(0,0,0,0.7); 
      color: white; border: none; border-radius: 4px; padding: 4px 8px; 
      cursor: pointer; font-size: 12px; opacity: 0; transition: opacity 0.2s;
    `;
    
    // Wrap pre in relative for positioning
    const pre = block.parentNode;
    pre.style.position = 'relative';
    pre.appendChild(button);
    
    // Hover to show button
    pre.addEventListener('mouseenter', () => { button.style.opacity = '1'; });
    pre.addEventListener('mouseleave', () => { button.style.opacity = '0'; });
    
    // Copy on click
    button.addEventListener('click', async () => {
      const text = block.textContent;
      try {
        await navigator.clipboard.writeText(text);
        button.innerHTML = '✅';
        button.title = 'Copied!';
        setTimeout(() => {
          button.innerHTML = '📋';
          button.title = 'Copy to clipboard';
        }, 2000);
      } catch (err) {
        console.error('Copy failed:', err);
        // Fallback for older browsers
        const range = document.createRange();
        range.selectNode(block);
        window.getSelection().addRange(range);
        document.execCommand('copy');
        window.getSelection().removeAllRanges();
      }
    });
  });
});
