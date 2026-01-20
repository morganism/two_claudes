// Conversation page JavaScript with real-time updates

let updateInterval;
let lastTurnCount = 0;

document.addEventListener('DOMContentLoaded', () => {
  // Start polling for updates
  loadConversationStatus();
  updateInterval = setInterval(loadConversationStatus, 2000); // Poll every 2 seconds
});

async function loadConversationStatus() {
  try {
    const response = await fetch(`/api/conversations/${conversationId}`);
    const data = await response.json();
    
    if (response.ok) {
      updateConversationUI(data);
      
      // Stop polling if conversation is complete
      if (data.conversation.status !== 'active') {
        clearInterval(updateInterval);
      }
    } else {
      console.error('Failed to load conversation:', data.error);
    }
  } catch (error) {
    console.error('Error loading conversation:', error);
  }
}

function updateConversationUI(data) {
  const { conversation, messages, latest_summary } = data;
  
  // Update header
  updateHeader(conversation);
  
  // Update messages
  updateMessages(messages);
  
  // Update summary
  if (latest_summary) {
    updateSummary(latest_summary);
  }
  
  // Update full transcript
  updateTranscript(messages);
}

function updateHeader(conversation) {
  // Update status badge
  const statusBadge = document.getElementById('statusBadge');
  statusBadge.textContent = conversation.status.toUpperCase();
  statusBadge.className = `badge ${getStatusClass(conversation.status)}`;
  
  // Update conversation info
  document.getElementById('conversationTitle').textContent = conversation.title;
  document.getElementById('turnCount').textContent = conversation.turn_count;
  document.getElementById('startTime').textContent = formatDateTime(conversation.created_at);
}

function updateMessages(messages) {
  const claudeAContainer = document.getElementById('claudeAMessages');
  const claude2Container = document.getElementById('claude2Messages');
  
  // Filter messages by instance
  const claudeAMessages = messages.filter(m => m.claude_instance === 'claude_a');
  const claude2Messages = messages.filter(m => m.claude_instance === 'claude_2');
  
  // Update Claude A messages
  if (claudeAMessages.length > 0) {
    claudeAContainer.innerHTML = claudeAMessages.map(msg => renderMessage(msg, 'a')).join('');
    scrollToBottom(claudeAContainer);
  }
  
  // Update Claude 2 messages
  if (claude2Messages.length > 0) {
    claude2Container.innerHTML = claude2Messages.map(msg => renderMessage(msg, '2')).join('');
    scrollToBottom(claude2Container);
  }
}

function renderMessage(message, instanceSuffix) {
  const roleClass = message.role === 'user' ? 'user' : 'assistant';
  const header = message.role === 'user' ? 'USER PROMPT' : `CLAUDE ${instanceSuffix.toUpperCase()}`;
  
  return `
    <div class="message-bubble ${roleClass}">
      <div class="message-header">${header}</div>
      <div class="message-content">${escapeHtml(message.content)}</div>
      <span class="turn-number">T${message.turn_number}</span>
    </div>
  `;
}

function updateSummary(summary) {
  const summaryPanel = document.getElementById('summaryPanel');
  
  summaryPanel.innerHTML = `
    <div class="summary-content">
      <div class="mb-2">
        <small class="text-muted">Summary up to turn ${summary.up_to_turn}</small>
      </div>
      <div class="summary-text">
        ${escapeHtml(summary.summary_text).replace(/\n/g, '<br>')}
      </div>
      <div class="mt-2">
        <small class="text-muted">${formatDateTime(summary.created_at)}</small>
      </div>
    </div>
  `;
}

function updateTranscript(messages) {
  const transcriptContainer = document.getElementById('fullTranscript');
  
  if (messages.length === 0) {
    transcriptContainer.innerHTML = `
      <div class="text-center text-muted py-3">
        <p class="small">No messages yet...</p>
      </div>
    `;
    return;
  }
  
  transcriptContainer.innerHTML = messages.map(msg => {
    const instanceClass = msg.claude_instance === 'claude_a' ? 'claude-a' : 'claude-2';
    const instanceLabel = msg.claude_instance === 'claude_a' ? 'Claude A' : 'Claude 2';
    const roleLabel = msg.role === 'user' ? 'User' : instanceLabel;
    
    return `
      <div class="transcript-entry ${instanceClass}">
        <div class="d-flex justify-content-between mb-2">
          <strong>${roleLabel}</strong>
          <small class="text-muted">Turn ${msg.turn_number} | ${formatDateTime(msg.created_at)}</small>
        </div>
        <div>${escapeHtml(msg.content)}</div>
        ${msg.tokens_used ? `<div class="mt-2"><small class="text-muted">Tokens: ${msg.tokens_used}</small></div>` : ''}
      </div>
    `;
  }).join('');
  
  // Scroll to bottom if new messages
  if (messages.length > lastTurnCount) {
    scrollToBottom(transcriptContainer);
    lastTurnCount = messages.length;
  }
}

function scrollToBottom(element) {
  element.scrollTop = element.scrollHeight;
}

function getStatusClass(status) {
  switch(status) {
    case 'active': return 'status-active';
    case 'completed': return 'status-completed';
    case 'error': return 'status-error';
    default: return '';
  }
}

function formatDateTime(dateString) {
  const date = new Date(dateString);
  return date.toLocaleString();
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}
