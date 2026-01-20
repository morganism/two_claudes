// Main app JavaScript for index page

document.addEventListener('DOMContentLoaded', () => {
  const startForm = document.getElementById('startConversationForm');
  const startBtn = document.getElementById('startBtn');
  const startSpinner = document.getElementById('startSpinner');
  const successModal = new bootstrap.Modal(document.getElementById('successModal'));
  const viewConversationLink = document.getElementById('viewConversationLink');
  
  // Load recent conversations
  loadRecentConversations();
  
  // Handle form submission
  startForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const prompt = document.getElementById('initialPrompt').value;
    const claudeAPrompt = document.getElementById('claudeAPrompt').value;
    const claude2Prompt = document.getElementById('claude2Prompt').value;
    const stoppingCondition = document.getElementById('stoppingCondition').value;
    
    // Show loading state
    startBtn.disabled = true;
    startSpinner.classList.remove('d-none');
    
    try {
      const response = await fetch('/api/conversations', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          prompt: prompt,
          claude_a_system_prompt: claudeAPrompt || null,
          claude_2_system_prompt: claude2Prompt || null,
          stopping_condition: stoppingCondition
        })
      });
      
      const data = await response.json();
      
      if (response.ok) {
        // Show success modal
        viewConversationLink.href = `/conversation/${data.conversation_id}`;
        successModal.show();
        
        // Reset form
        startForm.reset();
        
        // Reload recent conversations
        setTimeout(() => loadRecentConversations(), 1000);
      } else {
        alert('Error: ' + (data.error || 'Failed to start conversation'));
      }
    } catch (error) {
      alert('Error: ' + error.message);
    } finally {
      startBtn.disabled = false;
      startSpinner.classList.add('d-none');
    }
  });
});

async function loadRecentConversations() {
  const container = document.getElementById('recentConversations');
  
  try {
    const response = await fetch('/api/conversations');
    const data = await response.json();
    
    if (data.conversations && data.conversations.length > 0) {
      container.innerHTML = data.conversations.map(conv => `
        <div class="conversation-item" onclick="window.location.href='/conversation/${conv.id}'">
          <div class="d-flex justify-content-between align-items-start">
            <div class="flex-grow-1">
              <h6 class="mb-1">
                ${escapeHtml(conv.title)}
                <span class="badge badge-sm ${getStatusClass(conv.status)} ms-2">
                  ${conv.status}
                </span>
              </h6>
              <small class="text-muted">
                Turns: ${conv.turn_count} | Started: ${formatDate(conv.created_at)}
              </small>
            </div>
            <div class="text-end">
              <small class="text-muted">#${conv.id}</small>
            </div>
          </div>
        </div>
      `).join('');
    } else {
      container.innerHTML = `
        <div class="text-center text-muted py-3">
          <p class="mb-0">No conversations yet. Start your first one above!</p>
        </div>
      `;
    }
  } catch (error) {
    container.innerHTML = `
      <div class="alert alert-danger" role="alert">
        Failed to load conversations: ${error.message}
      </div>
    `;
  }
}

function getStatusClass(status) {
  switch(status) {
    case 'active': return 'status-active';
    case 'completed': return 'status-completed';
    case 'error': return 'status-error';
    default: return '';
  }
}

function formatDate(dateString) {
  const date = new Date(dateString);
  const now = new Date();
  const diffMs = now - date;
  const diffMins = Math.floor(diffMs / 60000);
  
  if (diffMins < 1) return 'Just now';
  if (diffMins < 60) return `${diffMins}m ago`;
  
  const diffHours = Math.floor(diffMins / 60);
  if (diffHours < 24) return `${diffHours}h ago`;
  
  const diffDays = Math.floor(diffHours / 24);
  if (diffDays < 7) return `${diffDays}d ago`;
  
  return date.toLocaleDateString();
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
